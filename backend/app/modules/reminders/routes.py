from flask import Blueprint, jsonify, request
from .models import Reminder
from app.core.database import db
from app.core.auth import token_required
from datetime import datetime

reminders_bp = Blueprint('reminders', __name__)

@reminders_bp.route('/ping')
def ping():
    return jsonify({"message": "reminders module is working"})

import traceback

@reminders_bp.route('/', methods=['GET'])
@token_required
def get_reminders(current_user):
    try:
        reminders = Reminder.query.filter_by(user_id=current_user.id, is_deleted=False).all()
        return jsonify([reminder.to_dict() for reminder in reminders])
    except Exception as e:
        print("Error fetching reminders:")
        traceback.print_exc()
        return jsonify({'message': 'Failed to fetch reminders', 'error': str(e)}), 500

@reminders_bp.route('/', methods=['POST'])
@token_required
def create_reminder(current_user):
    try:
        data = request.get_json()

        if not data or not data.get('title') or not data.get('trigger_time'):
            return jsonify({'message': 'Missing required fields: title, trigger_time'}), 400

        try:
            trigger_time = datetime.fromisoformat(data['trigger_time'].replace('Z', '+00:00'))
            if trigger_time.tzinfo is None:
                # If no timezone is provided, assume it's UTC since frontend sends ISO 8601 in UTC
                from datetime import timezone
                trigger_time = trigger_time.replace(tzinfo=timezone.utc)
        except ValueError:
            return jsonify({'message': 'Invalid trigger_time format'}), 400

        # Check if task_id exists to prevent foreign key constraint violations
        task_id = data.get('task_id')
        if task_id:
            from app.modules.tasks.models import Task
            task_exists = Task.query.filter_by(id=task_id).first()
            if not task_exists:
                # If the task doesn't exist on the backend yet, we clear the task_id
                # so the reminder can still be created without crashing
                task_id = None

        # Check if activity_id exists to prevent foreign key constraint violations
        activity_id = data.get('activity_id')
        if activity_id:
            from app.modules.activities.models import Activity
            activity_exists = Activity.query.filter_by(id=activity_id).first()
            if not activity_exists:
                activity_id = None

        new_reminder = Reminder(
            title=data['title'],
            message=data.get('message', ''),
            trigger_time=trigger_time,
            is_sent=data.get('is_sent', False),
            task_id=task_id,
            activity_id=activity_id,
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
    except Exception as e:
        db.session.rollback()
        print("Error creating reminder:")
        traceback.print_exc()
        return jsonify({'message': 'Failed to create reminder', 'error': str(e)}), 500

@reminders_bp.route('/<reminder_id>', methods=['PUT'])
@token_required
def update_reminder(current_user, reminder_id):
    try:
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
                    t_time = datetime.fromisoformat(data['trigger_time'].replace('Z', '+00:00'))
                    if t_time.tzinfo is None:
                        from datetime import timezone
                        t_time = t_time.replace(tzinfo=timezone.utc)
                    reminder.trigger_time = t_time
                except ValueError:
                    return jsonify({'message': 'Invalid trigger_time format'}), 400
            else:
                 return jsonify({'message': 'trigger_time is required'}), 400

        if 'is_sent' in data:
             reminder.is_sent = data['is_sent']

        if 'task_id' in data:
            task_id = data['task_id']
            if task_id:
                from app.modules.tasks.models import Task
                task_exists = Task.query.filter_by(id=task_id).first()
                if not task_exists:
                    task_id = None
            reminder.task_id = task_id

        if 'activity_id' in data:
            activity_id = data['activity_id']
            if activity_id:
                from app.modules.activities.models import Activity
                activity_exists = Activity.query.filter_by(id=activity_id).first()
                if not activity_exists:
                    activity_id = None
            reminder.activity_id = activity_id

        if 'is_deleted' in data:
            reminder.is_deleted = data['is_deleted']

        db.session.commit()
        return jsonify(reminder.to_dict())
    except Exception as e:
        db.session.rollback()
        print(f"Error updating reminder {reminder_id}:")
        traceback.print_exc()
        return jsonify({'message': 'Failed to update reminder', 'error': str(e)}), 500

@reminders_bp.route('/<reminder_id>', methods=['DELETE'])
@token_required
def delete_reminder(current_user, reminder_id):
    try:
        reminder = Reminder.query.filter_by(id=reminder_id, user_id=current_user.id).first()
        if not reminder:
            return jsonify({'message': 'Reminder not found'}), 404

        reminder.is_deleted = True
        db.session.commit()
        return jsonify({"message": "Reminder marked as deleted"}), 200
    except Exception as e:
        db.session.rollback()
        print(f"Error deleting reminder {reminder_id}:")
        traceback.print_exc()
        return jsonify({'message': 'Failed to delete reminder', 'error': str(e)}), 500
