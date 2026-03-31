import os
from dotenv import load_dotenv

load_dotenv()

class Config:
    FLASK_ENV = os.environ.get('FLASK_ENV', 'production')
    DEBUG = os.environ.get('FLASK_DEBUG', 'False').lower() in ('true', '1', 't')

    # Ensure SECRET_KEY is set in production
    SECRET_KEY = os.environ.get('SECRET_KEY')
    if FLASK_ENV == 'production' and not SECRET_KEY:
        raise ValueError("No SECRET_KEY set for Flask application in production")
    elif not SECRET_KEY:
        SECRET_KEY = 'dev-secret-key-change-in-production'

    # Handle Render's postgres:// vs postgresql:// for SQLAlchemy 1.4+
    db_url = os.environ.get('DATABASE_URL', 'sqlite:///local_dev.db')
    if db_url and db_url.startswith("postgres://"):
        db_url = db_url.replace("postgres://", "postgresql://", 1)

    SQLALCHEMY_DATABASE_URI = db_url
    SQLALCHEMY_TRACK_MODIFICATIONS = False

    # SMTP Settings for Password Reset
    MAIL_SERVER = os.environ.get('MAIL_SERVER') or 'smtp.gmail.com'
    MAIL_PORT = int(os.environ.get('MAIL_PORT') or 587)
    MAIL_USE_TLS = os.environ.get('MAIL_USE_TLS', 'True').lower() in ['true', '1']
    MAIL_USERNAME = os.environ.get('MAIL_USERNAME')
    MAIL_PASSWORD = os.environ.get('MAIL_PASSWORD')
    MAIL_DEFAULT_SENDER = os.environ.get('MAIL_DEFAULT_SENDER') or 'noreply@odak.com'

    # Frontend URL for links
    FRONTEND_URL = os.environ.get('FRONTEND_URL') or 'http://localhost:5001' # Web port or local default
