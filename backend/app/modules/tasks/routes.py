from flask import Blueprint, jsonify, request
from .models import Task
from app.core.database import db
from app.core.auth import token_required

tasks_bp = Blueprint('tasks', __name__)

@tasks_bp.route('/ping')
def ping():
    return jsonify({"message": "tasks module is working"})

@tasks_bp.route('/', methods=['GET'])
@token_required
def get_tasks(current_user):
    tasks = Task.query.filter_by(user_id=current_user.id, is_deleted=False).all()
    return jsonify([task.to_dict() for task in tasks])

@tasks_bp.route('/', methods=['POST'])
@token_required
def create_task(current_user):
    data = request.get_json()
    if not data:
        return jsonify({'message': 'Missing JSON body'}), 400

    from datetime import datetime

    deadline_val = data.get('deadline')
    if deadline_val:
        try:
            if deadline_val.endswith('Z'):
                deadline_val = deadline_val[:-1] + '+00:00'
            deadline_val = datetime.fromisoformat(deadline_val)
        except:
            deadline_val = None

    new_task = Task(
        title=data.get('title'),
        description=data.get('description', ''),
        is_completed=data.get('is_completed', False),
        user_id=current_user.id,
        list_id=data.get('list_id'),
        deadline=deadline_val,
        remind_via_email=data.get('remind_via_email', False)
    )

    # If the client (offline-first) provides its own UUID, use it to maintain sync parity.
    if 'id' in data and data['id']:
        # Check if it already exists to prevent duplicate inserts from retry logic
        existing_task = Task.query.filter_by(id=data['id'], user_id=current_user.id).first()
        if existing_task:
            return jsonify(existing_task.to_dict()), 200
        new_task.id = data['id']

    db.session.add(new_task)
    db.session.commit()
    return jsonify(new_task.to_dict()), 201

@tasks_bp.route('/<task_id>', methods=['PUT'])
@token_required
def update_task(current_user, task_id):
    task = Task.query.filter_by(id=task_id, user_id=current_user.id).first()
    if not task:
        return jsonify({'message': 'Task not found'}), 404

    data = request.get_json()
    if not data:
        return jsonify({'message': 'Missing JSON body'}), 400

    if 'title' in data:
        task.title = data['title']
    if 'description' in data:
        task.description = data['description']
    if 'is_completed' in data:
        task.is_completed = data['is_completed']
    if 'list_id' in data:
        task.list_id = data['list_id']
    if 'deadline' in data:
        from datetime import datetime
        val = data['deadline']
        if val:
            try:
                if val.endswith('Z'):
                    val = val[:-1] + '+00:00'
                task.deadline = datetime.fromisoformat(val)
            except:
                task.deadline = None
        else:
            task.deadline = None
    if 'remind_via_email' in data:
        task.remind_via_email = data['remind_via_email']
    if 'is_deleted' in data:
        task.is_deleted = data['is_deleted']

    db.session.commit()
    return jsonify(task.to_dict())

@tasks_bp.route('/<task_id>', methods=['DELETE'])
@token_required
def delete_task(current_user, task_id):
    # We use soft delete for sync purposes
    task = Task.query.filter_by(id=task_id, user_id=current_user.id).first()
    if not task:
        return jsonify({'message': 'Task not found'}), 404

    task.is_deleted = True
    db.session.commit()
    return jsonify({"message": "Task marked as deleted"}), 200

import os
from werkzeug.utils import secure_filename
from flask import current_app
from .models import TaskAttachment

UPLOAD_FOLDER = os.path.join(os.getcwd(), 'uploads', 'attachments')
os.makedirs(UPLOAD_FOLDER, exist_ok=True)

@tasks_bp.route('/<task_id>/attachments', methods=['GET'])
@token_required
def get_task_attachments(current_user, task_id):
    task = Task.query.filter_by(id=task_id, user_id=current_user.id).first()
    if not task:
        return jsonify({'message': 'Task not found'}), 404

    attachments = TaskAttachment.query.filter_by(task_id=task_id).all()
    return jsonify([att.to_dict() for att in attachments])

@tasks_bp.route('/<task_id>/attachments', methods=['POST'])
@token_required
def upload_task_attachment(current_user, task_id):
    task = Task.query.filter_by(id=task_id, user_id=current_user.id).first()
    if not task:
        return jsonify({'message': 'Task not found'}), 404

    if 'file' not in request.files:
        return jsonify({'message': 'No file part'}), 400

    file = request.files['file']
    if file.filename == '':
        return jsonify({'message': 'No selected file'}), 400

    if file:
        filename = secure_filename(file.filename)
        # Unique filename to avoid collisions
        unique_filename = f"{task_id}_{filename}"
        filepath = os.path.join(UPLOAD_FOLDER, unique_filename)
        file.save(filepath)

        attachment = TaskAttachment(
            task_id=task_id,
            file_name=filename,
            file_path=unique_filename
        )
        db.session.add(attachment)
        db.session.commit()

        return jsonify(attachment.to_dict()), 201

@tasks_bp.route('/attachments/<attachment_id>', methods=['DELETE'])
@token_required
def delete_task_attachment(current_user, attachment_id):
    attachment = TaskAttachment.query.get(attachment_id)
    if not attachment:
        return jsonify({'message': 'Attachment not found'}), 404

    # Ensure the task belongs to the user
    task = Task.query.filter_by(id=attachment.task_id, user_id=current_user.id).first()
    if not task:
        return jsonify({'message': 'Unauthorized'}), 401

    filepath = os.path.join(UPLOAD_FOLDER, attachment.file_path)
    if os.path.exists(filepath):
        os.remove(filepath)

    db.session.delete(attachment)
    db.session.commit()
    return jsonify({'message': 'Attachment deleted'}), 200
