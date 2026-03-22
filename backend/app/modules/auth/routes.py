from flask import Blueprint, jsonify, request, current_app
from app.modules.auth.models import User
from app.core.database import db
from app.core.auth import token_required
from app.core.mail import mail
from flask_mail import Message
import jwt
import datetime

auth_bp = Blueprint('auth', __name__)

def generate_tokens(user_id):
    access_token = jwt.encode({
        'user_id': user_id,
        'type': 'access',
        'exp': datetime.datetime.now(datetime.timezone.utc) + datetime.timedelta(hours=1)
    }, current_app.config['SECRET_KEY'], algorithm="HS256")

    refresh_token = jwt.encode({
        'user_id': user_id,
        'type': 'refresh',
        'exp': datetime.datetime.now(datetime.timezone.utc) + datetime.timedelta(days=30)
    }, current_app.config['SECRET_KEY'], algorithm="HS256")

    return access_token, refresh_token

@auth_bp.route('/ping')
def ping():
    return jsonify({"message": "auth module is working"})

@auth_bp.route('/register', methods=['POST'])
def register():
    data = request.get_json()
    if not data or not data.get('username') or not data.get('email') or not data.get('password'):
        return jsonify({'message': 'Missing required fields'}), 400

    if User.query.filter_by(username=data['username']).first():
        return jsonify({'message': 'Username already exists'}), 400

    if User.query.filter_by(email=data['email']).first():
        return jsonify({'message': 'Email already exists'}), 400

    new_user = User(username=data['username'], email=data['email'])
    new_user.set_password(data['password'])

    db.session.add(new_user)
    db.session.commit()

    return jsonify({'message': 'User registered successfully', 'user': new_user.to_dict()}), 201

@auth_bp.route('/login', methods=['POST'])
def login():
    data = request.get_json()
    if not data or not data.get('username') or not data.get('password'):
        return jsonify({'message': 'Missing required fields'}), 400

    user = User.query.filter_by(username=data['username']).first()

    if not user or not user.check_password(data['password']):
        return jsonify({'message': 'Invalid username or password'}), 401

    access_token, refresh_token = generate_tokens(user.id)

    return jsonify({
        'token': access_token,
        'refresh_token': refresh_token,
        'user': user.to_dict()
    }), 200

@auth_bp.route('/refresh', methods=['POST'])
def refresh():
    data = request.get_json()
    refresh_token = data.get('refresh_token')
    if not refresh_token:
        return jsonify({'message': 'Refresh token missing'}), 400

    try:
        data = jwt.decode(refresh_token, current_app.config['SECRET_KEY'], algorithms=["HS256"])
        if data.get('type') != 'refresh':
            return jsonify({'message': 'Invalid token type'}), 401
        user_id = data['user_id']
        user = User.query.get(user_id)
        if not user:
            return jsonify({'message': 'User not found'}), 401

        access_token, new_refresh_token = generate_tokens(user.id)
        return jsonify({
            'token': access_token,
            'refresh_token': new_refresh_token
        }), 200
    except Exception as e:
        return jsonify({'message': 'Invalid or expired refresh token'}), 401

@auth_bp.route('/me', methods=['GET'])
@token_required
def me(current_user):
    return jsonify(current_user.to_dict()), 200

@auth_bp.route('/forgot-password', methods=['POST'])
def forgot_password():
    data = request.get_json()
    email = data.get('email')
    if not email:
        return jsonify({'message': 'Email is required'}), 400

    user = User.query.filter_by(email=email).first()
    if not user:
        return jsonify({'message': 'If the email exists, a reset link will be sent.'}), 200

    reset_token = jwt.encode({
        'user_id': user.id,
        'type': 'reset',
        'exp': datetime.datetime.now(datetime.timezone.utc) + datetime.timedelta(hours=1)
    }, current_app.config['SECRET_KEY'], algorithm="HS256")

    try:
        msg = Message("Password Reset for ODAK", recipients=[user.email])
        msg.body = f"Hello {user.username},\n\nYou requested a password reset. Use the following token to reset your password:\n\n{reset_token}\n\nIf you did not request this, please ignore this email.\n\nODAK Team"
        mail.send(msg)
        current_app.logger.info(f"Password reset link generated and emailed for {email}: reset_token={reset_token}")
    except Exception as e:
        current_app.logger.error(f"Failed to send password reset email to {email}: {str(e)}")
        # We don't want to expose email server failures to the user for security/UX reasons.

    return jsonify({'message': 'If the email exists, a reset link will be sent.'}), 200

@auth_bp.route('/reset-password', methods=['POST'])
def reset_password():
    data = request.get_json()
    token = data.get('token')
    new_password = data.get('new_password')

    if not token or not new_password:
        return jsonify({'message': 'Token and new_password are required'}), 400

    try:
        payload = jwt.decode(token, current_app.config['SECRET_KEY'], algorithms=["HS256"])
        if payload.get('type') != 'reset':
            return jsonify({'message': 'Invalid token type'}), 400

        user = User.query.get(payload['user_id'])
        if not user:
            return jsonify({'message': 'User not found'}), 404

        user.set_password(new_password)
        db.session.commit()
        return jsonify({'message': 'Password has been reset successfully'}), 200

    except jwt.ExpiredSignatureError:
        return jsonify({'message': 'Reset token has expired'}), 400
    except Exception as e:
        return jsonify({'message': 'Invalid reset token'}), 400
