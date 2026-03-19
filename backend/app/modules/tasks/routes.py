from flask import Blueprint, jsonify

tasks_bp = Blueprint('tasks', __name__)

@tasks_bp.route('/ping')
def ping():
    return jsonify({"message": "tasks module is working"})
