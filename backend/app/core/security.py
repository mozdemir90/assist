from flask_cors import CORS
from flask_limiter import Limiter
from flask_limiter.util import get_remote_address

limiter = Limiter(
    key_func=get_remote_address,
    default_limits=["60 per minute"],
    storage_uri="memory://"  # We are using an in-memory storage for rate limiting, as Redis is not allowed/not lightweight
)

def init_security(app):
    """
    Sets up fundamental security components:
    - Flask-CORS to control cross-origin access.
    - Flask-Limiter for basic rate limiting to protect API endpoints.
    """
    # Her yerden erişime izin ver (Gerekirse bu kısıtlanabilir, örn: origins=['http://localhost:3000'])
    CORS(app, resources={r"/api/*": {"origins": "*"}})

    # Rate Limiter'ı uygulamaya bağla
    limiter.init_app(app)
