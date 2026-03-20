from flask import jsonify, request
from . import lists_bp
from .models import List
from app.core.database import db
from app.core.auth import token_required

@lists_bp.route('/ping')
def ping():
    return jsonify({"message": "lists module is working"})

@lists_bp.route('/', methods=['GET'])
@token_required
def get_lists(current_user):
    lists = List.query.filter_by(user_id=current_user.id, is_deleted=False).all()
    return jsonify([lst.to_dict() for lst in lists])

@lists_bp.route('/', methods=['POST'])
@token_required
def create_list(current_user):
    data = request.get_json()
    if not data:
        return jsonify({'message': 'Missing JSON body'}), 400

    new_list = List(
        name=data.get('name'),
        color=data.get('color', '#FFFFFF'),
        user_id=current_user.id
    )

    if 'id' in data and data['id']:
        existing_list = List.query.filter_by(id=data['id'], user_id=current_user.id).first()
        if existing_list:
            return jsonify(existing_list.to_dict()), 200
        new_list.id = data['id']

    db.session.add(new_list)
    db.session.commit()
    return jsonify(new_list.to_dict()), 201

@lists_bp.route('/<list_id>', methods=['PUT'])
@token_required
def update_list(current_user, list_id):
    lst = List.query.filter_by(id=list_id, user_id=current_user.id).first()
    if not lst:
        return jsonify({'message': 'List not found'}), 404

    data = request.get_json()
    if not data:
        return jsonify({'message': 'Missing JSON body'}), 400

    if 'name' in data:
        lst.name = data['name']
    if 'color' in data:
        lst.color = data['color']
    if 'is_deleted' in data:
        lst.is_deleted = data['is_deleted']

    db.session.commit()
    return jsonify(lst.to_dict())

@lists_bp.route('/<list_id>', methods=['DELETE'])
@token_required
def delete_list(current_user, list_id):
    lst = List.query.filter_by(id=list_id, user_id=current_user.id).first()
    if not lst:
        return jsonify({'message': 'List not found'}), 404

    lst.is_deleted = True
    db.session.commit()
    return jsonify({"message": "List marked as deleted"}), 200
