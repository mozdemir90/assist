from flask import Flask
from .core.config import Config
from .core.database import db
from flask_migrate import Migrate

migrate = Migrate()

from .core.logger import init_logger
from .core.security import init_security
from .core.scheduler import init_scheduler

def create_app(config_class=Config):
    app = Flask(__name__)
    app.config.from_object(config_class)

    # 1. Init Logging first so that other modules can log properly
    init_logger(app)

    # 2. Init Security (CORS, Rate Limiting)
    init_security(app)

    db.init_app(app)
    migrate.init_app(app, db)

    # 3. Init Scheduler
    init_scheduler(app)

    # Import models so SQLAlchemy creates tables
    with app.app_context():
        from .modules.tasks import models as task_models
        from .modules.auth import models as auth_models

    # Register Blueprints
    from .modules.auth.routes import auth_bp
    from .modules.tasks.routes import tasks_bp
    from .modules.sync.routes import sync_bp

    app.register_blueprint(auth_bp, url_prefix='/api/auth')
    app.register_blueprint(tasks_bp, url_prefix='/api/tasks')
    app.register_blueprint(sync_bp, url_prefix='/api/sync')

    @app.route('/health')
    def health_check():
        return {'status': 'healthy'}

    return app
