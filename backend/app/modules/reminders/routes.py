from flask import Blueprint, jsonify, request
from .models import Reminder
from app.core.database import db
from app.core.auth import token_required
from datetime import datetime

reminders_bp = Blueprint('reminders', __name__)

@reminders_bp.route('/ping')
def ping():
    return jsonify({"message": "reminders module is working"})

@reminders_bp.route('/', methods=['GET'])
@token_required
def get_reminders(current_user):
    reminders = Reminder.query.filter_by(user_id=current_user.id, is_deleted=False).all()
    return jsonify([reminder.to_dict() for reminder in reminders])

@reminders_bp.route('/', methods=['POST'])
@token_required
def create_reminder(current_user):
    data = request.get_json()

    if not data or not data.get('title') or not data.get('trigger_time'):
        return jsonify({'message': 'Missing required fields: title, trigger_time'}), 400

    try:
        trigger_time = datetime.fromisoformat(data['trigger_time'].replace('Z', '+00:00'))
    except ValueError:
        return jsonify({'message': 'Invalid trigger_time format'}), 400

    new_reminder = Reminder(
        title=data['title'],
        message=data.get('message', ''),
        trigger_time=trigger_time,
        is_sent=data.get('is_sent', False),
        task_id=data.get('task_id'),
        activity_id=data.get('activity_id'),
        user_id=current_user.id
    )

    if 'id' in data and data['id']:
        existing_reminder = Reminder.query.filter_by(id=data['id'], user_id=current_user.id).first()
        if existing_reminder:
            return jsonify(existing_reminder.to_dict()), 200
        new_reminder.id = data['id']

    db.session.add(new_reminder)
    db.session.commit()
    return jsonify(new_reminder.to_dict()), 201

@reminders_bp.route('/<reminder_id>', methods=['PUT'])
@token_required
def update_reminder(current_user, reminder_id):
    reminder = Reminder.query.filter_by(id=reminder_id, user_id=current_user.id).first()
    if not reminder:
        return jsonify({'message': 'Reminder not found'}), 404

    data = request.get_json()
    if not data:
        return jsonify({'message': 'Missing JSON body'}), 400

    if 'title' in data:
        reminder.title = data['title']
    if 'message' in data:
        reminder.message = data['message']

    if 'trigger_time' in data:
        if data['trigger_time']:
            try:
                reminder.trigger_time = datetime.fromisoformat(data['trigger_time'].replace('Z', '+00:00'))
            except ValueError:
                return jsonify({'message': 'Invalid trigger_time format'}), 400
        else:
             return jsonify({'message': 'trigger_time is required'}), 400

    if 'is_sent' in data:
         reminder.is_sent = data['is_sent']

    if 'task_id' in data:
         reminder.task_id = data['task_id']

    if 'activity_id' in data:
         reminder.activity_id = data['activity_id']

    if 'is_deleted' in data:
        reminder.is_deleted = data['is_deleted']

    db.session.commit()
    return jsonify(reminder.to_dict())

@reminders_bp.route('/<reminder_id>', methods=['DELETE'])
@token_required
def delete_reminder(current_user, reminder_id):
    reminder = Reminder.query.filter_by(id=reminder_id, user_id=current_user.id).first()
    if not reminder:
        return jsonify({'message': 'Reminder not found'}), 404

    reminder.is_deleted = True
    db.session.commit()
    return jsonify({"message": "Reminder marked as deleted"}), 200
