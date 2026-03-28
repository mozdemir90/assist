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
