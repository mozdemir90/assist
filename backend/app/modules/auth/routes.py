from flask import Blueprint, jsonify, request, current_app
from app.modules.auth.models import User
from app.core.database import db
from functools import wraps
import jwt
import datetime
import smtplib
from email.mime.text import MIMEText
from email.mime.multipart import MIMEMultipart
import traceback

auth_bp = Blueprint('auth', __name__)

def send_reset_email(to_email, reset_link):
    sender = current_app.config.get('MAIL_USERNAME')
    password = current_app.config.get('MAIL_PASSWORD')
    server = current_app.config.get('MAIL_SERVER')
    port = current_app.config.get('MAIL_PORT')
    default_sender = current_app.config.get('MAIL_DEFAULT_SENDER')

    # Mock success if no credentials for local dev
    if not sender or not password:
        print(f"Mock Email: To {to_email}, Link: {reset_link}")
        return True

    msg = MIMEMultipart("alternative")
    msg["Subject"] = "ODAK - Password Reset"
    msg["From"] = default_sender
    msg["To"] = to_email

    text = f"Hello,\n\nTo reset your ODAK password, please click the following link:\n{reset_link}\n\nIf you didn't request this, you can safely ignore this email.\n"
    msg.attach(MIMEText(text, "plain"))

    try:
        print(f"Attempting to send email via SMTP {server}:{port} (TLS: {current_app.config.get('MAIL_USE_TLS')})")
        with smtplib.SMTP(server, port, timeout=10) as smtp:
            smtp.set_debuglevel(1) # Enables verbose SMTP logging in the console
            if current_app.config.get('MAIL_USE_TLS'):
                smtp.starttls()
            smtp.login(sender, password)
            smtp.sendmail(default_sender, to_email, msg.as_string())
        print(f"Successfully sent reset email to {to_email}")
        return True
    except smtplib.SMTPAuthenticationError as e:
        print("SMTP Authentication Error! Check MAIL_USERNAME and MAIL_PASSWORD (did you use an App Password for Gmail?).")
        traceback.print_exc()
        return False
    except smtplib.SMTPConnectError as e:
        print(f"SMTP Connection Error! Failed to connect to {server}:{port}.")
        traceback.print_exc()
        return False
    except Exception as e:
        print(f"Unexpected error sending email:")
        traceback.print_exc()
        return False

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

    token = jwt.encode({
        'user_id': user.id,
        'exp': datetime.datetime.now(datetime.timezone.utc) + datetime.timedelta(days=7) # Token valid for 7 days
    }, current_app.config['SECRET_KEY'], algorithm="HS256")

    return jsonify({'token': token, 'user': user.to_dict()}), 200

@auth_bp.route('/forgot-password', methods=['POST'])
def forgot_password():
    data = request.get_json()
    if not data or not data.get('email'):
        return jsonify({'message': 'Missing email'}), 400

    user = User.query.filter_by(email=data['email']).first()
    if not user:
        # Prevent email enumeration by returning success anyway
        return jsonify({'message': 'If an account exists with that email, a password reset link has been sent.'}), 200

    token = jwt.encode({
        'user_id': user.id,
        'reset_password': True,
        'exp': datetime.datetime.now(datetime.timezone.utc) + datetime.timedelta(hours=1)
    }, current_app.config['SECRET_KEY'], algorithm="HS256")

    # Determine the fallback mechanism for deep linking on mobile or fallback web
    import os
    frontend_url = os.getenv('FRONTEND_URL')

    if frontend_url:
        reset_link = f"{frontend_url}/reset-password?token={token}"
    else:
        # Fallback to local address if running locally, or a deeplink if configured
        # Note: In a pure Flutter mobile application environment, we typically use a deeplink (e.g., odak://)
        # or the API host itself if we serve a web page. Since we lack FRONTEND_URL, fallback to request.host_url
        reset_link = f"{request.host_url}reset-password?token={token}"
        print(f"Warning: FRONTEND_URL is missing. Falling back to {reset_link}")

    success = send_reset_email(user.email, reset_link)
    if not success:
        return jsonify({'message': 'Failed to send email. Please check server configuration.'}), 500

    return jsonify({'message': 'If an account exists with that email, a password reset link has been sent.'}), 200

def token_required(f):
    @wraps(f)
    def decorated(*args, **kwargs):
        token = None
        if 'Authorization' in request.headers:
            parts = request.headers['Authorization'].split()
            if len(parts) == 2 and parts[0] == 'Bearer':
                token = parts[1]

        if not token:
            return jsonify({'message': 'Token is missing'}), 401

        try:
            data = jwt.decode(token, current_app.config['SECRET_KEY'], algorithms=["HS256"])
            current_user = User.query.get(data['user_id'])
        except Exception:
            return jsonify({'message': 'Token is invalid'}), 401

        return f(current_user, *args, **kwargs)
    return decorated

@auth_bp.route('/fcm-token', methods=['POST'])
@token_required
def update_fcm_token(current_user):
    data = request.get_json()
    if not data or 'fcm_token' not in data:
        return jsonify({'message': 'Missing fcm_token'}), 400

    current_user.fcm_token = data['fcm_token']
    db.session.commit()

    return jsonify({'message': 'FCM token updated successfully'}), 200

@auth_bp.route('/reset-password', methods=['POST'])
def reset_password():
    data = request.get_json()
    if not data or not data.get('token') or not data.get('new_password'):
        return jsonify({'message': 'Missing required fields'}), 400

    token = data['token']
    new_password = data['new_password']

    try:
        decoded_token = jwt.decode(token, current_app.config['SECRET_KEY'], algorithms=["HS256"])
        if not decoded_token.get('reset_password'):
            return jsonify({'message': 'Invalid token type'}), 400
        user_id = decoded_token.get('user_id')
    except jwt.ExpiredSignatureError:
        return jsonify({'message': 'Token has expired'}), 400
    except jwt.InvalidTokenError:
        return jsonify({'message': 'Invalid token'}), 400

    user = User.query.get(user_id)
    if not user:
        return jsonify({'message': 'User not found'}), 404

    user.set_password(new_password)
    db.session.commit()

    return jsonify({'message': 'Password has been reset successfully'}), 200

@auth_bp.route('/me', methods=['GET'])
@token_required
def get_me(current_user):
    return jsonify(current_user.to_dict()), 200
