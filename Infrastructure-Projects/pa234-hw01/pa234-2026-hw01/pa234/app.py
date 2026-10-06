import logging

from flask import Flask
from flask_cors import CORS
from werkzeug.debug import DebuggedApplication

from pa234.config import DevelopmentConfig
from pa234.blueprints import status
from pa234.blueprints import index

# Import ProxyFix at module level so the name exists regardless of availability
try:
    from werkzeug.middleware.proxy_fix import ProxyFix
except Exception:
    ProxyFix = None


def create_app(config_class=DevelopmentConfig):
    app = Flask(__name__, static_folder="static")

    app.config.from_object(config_class)

    cors_kwargs = {}
    if app.config["CORS_ALLOWED_ORIGIN"] is not None:
        cors_kwargs["resources"] = {r"*": {"origins": app.config["CORS_ALLOWED_ORIGIN"]}}
    CORS(app, **cors_kwargs)

    app.register_blueprint(index.routes.index_bp)
    app.register_blueprint(status.routes.status_bp)

    logging.basicConfig(
        level=logging.DEBUG,
    )

    app.wsgi_app = DebuggedApplication(app.wsgi_app, True)

    if ProxyFix is not None:
        app.wsgi_app = ProxyFix(app.wsgi_app, x_for=1, x_proto=1, x_host=1, x_port=1)

    return app
