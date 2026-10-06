import os


def get_env_variable(name):
    value = os.environ.get(name)
    if value is not None:
        return value
    raise Exception("Expected environment variable '{}' not set.".format(name))

def get_env_variable_with_default(name, default=None):
    try:
        return get_env_variable(name)
    except Exception:
        return default


class Config(object):
    CORS_ALLOWED_ORIGIN = get_env_variable_with_default("CORS_ALLOWED_ORIGIN")


class DevelopmentConfig(Config):
    DEBUG = True


class TestingConfig(Config):
    DEBUG = True
    TESTING = True
