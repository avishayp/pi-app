import os
from flask import Flask
from .routes import bp
from .logger import log

# init
app = Flask(__name__)
app.url_map.strict_slashes = False
app.register_blueprint(bp, url_prefix='/v1')

log.info('app module loaded')


if __name__ == "__main__":
    _host = os.environ.get('HOST', '0.0.0.0')
    _port = os.environ.get('PORT', 8080)
    log.info('app listening on %s:%s', _host, _port)
    app.run(host=_host, port=_port)
