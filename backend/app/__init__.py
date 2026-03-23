from flask import Flask
from .core.config import Config
from .core.database import db
from .core.mail import mail
from flask_migrate import Migrate
from apscheduler.schedulers.background import BackgroundScheduler
import logging

migrate = Migrate()
scheduler = BackgroundScheduler()

def create_app(config_class=Config):
    app = Flask(__name__)
    app.config.from_object(config_class)

    db.init_app(app)
    migrate.init_app(app, db)
<<<<<<< Updated upstream

    from flask_cors import CORS
    CORS(app, resources={r"/api/*": {"origins": "*"}})
=======
    mail.init_app(app)

    # Initialize Scheduler
    if not scheduler.running:
        from .core.scheduler import setup_jobs
        setup_jobs(scheduler, app)
        scheduler.start()
>>>>>>> Stashed changes

    # Import models so SQLAlchemy creates tables
    with app.app_context():
        from .modules.auth import models as auth_models
        from .modules.tasks import models as task_models
        from .modules.activities import models as activity_models
        from .modules.reminders import models as reminder_models
        from .modules.lists import models as list_models

    # Register Blueprints
    from .modules.auth.routes import auth_bp
    from .modules.tasks.routes import tasks_bp
    from .modules.activities.routes import activities_bp
    from .modules.reminders.routes import reminders_bp
    from .modules.sync.routes import sync_bp
    from .modules.lists.routes import lists_bp

    app.register_blueprint(auth_bp, url_prefix='/api/auth')
    app.register_blueprint(tasks_bp, url_prefix='/api/tasks')
    app.register_blueprint(activities_bp, url_prefix='/api/activities')
    app.register_blueprint(reminders_bp, url_prefix='/api/reminders')
    app.register_blueprint(sync_bp, url_prefix='/api/sync')
    app.register_blueprint(lists_bp, url_prefix='/api/lists')

    @app.route('/health')
    def health_check():
        return {'status': 'healthy'}

    return app
