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

    new_task = Task(
        title=data.get('title'),
        description=data.get('description', ''),
        is_completed=data.get('is_completed', False),
        user_id=current_user.id
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
