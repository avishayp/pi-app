from flask import Blueprint

bp = Blueprint('v1', __name__)


@bp.route("/")
def health():
    return "hello, api"
