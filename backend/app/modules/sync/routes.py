from flask import Blueprint, jsonify

sync_bp = Blueprint('sync', __name__)

@sync_bp.route('/ping')
def ping():
    return jsonify({"message": "sync module is working"})
