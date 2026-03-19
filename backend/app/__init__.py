from flask import Flask
from .core.config import Config
from .core.database import db
from flask_migrate import Migrate

migrate = Migrate()

def create_app(config_class=Config):
    app = Flask(__name__)
    app.config.from_object(config_class)

    db.init_app(app)
    migrate.init_app(app, db)

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
