from flask import Blueprint, jsonify, request
from .models import Activity
from app.core.database import db
from app.core.auth import token_required
from datetime import datetime

activities_bp = Blueprint('activities', __name__)

@activities_bp.route('/ping')
def ping():
    return jsonify({"message": "activities module is working"})

@activities_bp.route('/', methods=['GET'])
@token_required
def get_activities(current_user):
    activities = Activity.query.filter_by(user_id=current_user.id, is_deleted=False).all()
    return jsonify([activity.to_dict() for activity in activities])

@activities_bp.route('/', methods=['POST'])
@token_required
def create_activity(current_user):
    data = request.get_json()
    if not data:
        return jsonify({'message': 'Missing JSON body'}), 400

    start_time = None
    if data.get('start_time'):
        try:
            start_time = datetime.fromisoformat(data['start_time'].replace('Z', '+00:00'))
        except ValueError:
            return jsonify({'message': 'Invalid start_time format'}), 400

    end_time = None
    if data.get('end_time'):
        try:
            end_time = datetime.fromisoformat(data['end_time'].replace('Z', '+00:00'))
        except ValueError:
            return jsonify({'message': 'Invalid end_time format'}), 400

    new_activity = Activity(
        title=data.get('title'),
        description=data.get('description', ''),
        start_time=start_time,
        end_time=end_time,
        duration=data.get('duration'),
        user_id=current_user.id
    )

    if 'id' in data and data['id']:
        existing_activity = Activity.query.filter_by(id=data['id'], user_id=current_user.id).first()
        if existing_activity:
            return jsonify(existing_activity.to_dict()), 200
        new_activity.id = data['id']

    db.session.add(new_activity)
    db.session.commit()
    return jsonify(new_activity.to_dict()), 201

@activities_bp.route('/<activity_id>', methods=['PUT'])
@token_required
def update_activity(current_user, activity_id):
    activity = Activity.query.filter_by(id=activity_id, user_id=current_user.id).first()
    if not activity:
        return jsonify({'message': 'Activity not found'}), 404

    data = request.get_json()
    if not data:
        return jsonify({'message': 'Missing JSON body'}), 400

    if 'title' in data:
        activity.title = data['title']
    if 'description' in data:
        activity.description = data['description']

    if 'start_time' in data:
        if data['start_time']:
            try:
                activity.start_time = datetime.fromisoformat(data['start_time'].replace('Z', '+00:00'))
            except ValueError:
                return jsonify({'message': 'Invalid start_time format'}), 400
        else:
             activity.start_time = None

    if 'end_time' in data:
        if data['end_time']:
            try:
                activity.end_time = datetime.fromisoformat(data['end_time'].replace('Z', '+00:00'))
            except ValueError:
                 return jsonify({'message': 'Invalid end_time format'}), 400
        else:
             activity.end_time = None

    if 'duration' in data:
        activity.duration = data['duration']

    if 'is_deleted' in data:
        activity.is_deleted = data['is_deleted']

    db.session.commit()
    return jsonify(activity.to_dict())

@activities_bp.route('/<activity_id>', methods=['DELETE'])
@token_required
def delete_activity(current_user, activity_id):
    activity = Activity.query.filter_by(id=activity_id, user_id=current_user.id).first()
    if not activity:
        return jsonify({'message': 'Activity not found'}), 404

    activity.is_deleted = True
    db.session.commit()
    return jsonify({"message": "Activity marked as deleted"}), 200
