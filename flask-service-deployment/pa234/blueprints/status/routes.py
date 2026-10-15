import os
from datetime import datetime, timezone
from zoneinfo import ZoneInfo, ZoneInfoNotFoundError

from flask import Blueprint, jsonify, request

import socket


status_bp = Blueprint("status", __name__, url_prefix="/status")


@status_bp.route("/uco", methods=["GET"])
def uco():
    uco_id = os.getenv("UCO")
    uco_name = os.getenv("NAME")

    uco_name_data = {
        "uco": uco_id,
        "name": uco_name
    }

    return jsonify(uco_name_data)


def software_version():
    sw_version_data = os.getenv("SOFTWARE_VERSION")

    if not sw_version_data:
        sw_version_data = "not_specified"

    sw_version_data = {
        "version": sw_version_data
    }

    return sw_version_data

def hostname():
    hostname_name = socket.gethostname()

    hostname_data = {
        "hostname": hostname_name
    }

    return hostname_data


def os_name():
    os_name_name = os.name

    os_name_data = {
        "os_name": os_name_name
    }

    return os_name_data

@status_bp.route("/", methods=["GET"])
def status():
    status_data = {}
    status_data.update(software_version())
    status_data.update(hostname())
    status_data.update(os_name())

    return jsonify(status_data)

@status_bp.route("/date", methods=["GET"])
def date():
    timezone_param = request.args.get("timezone")

    # sanitize the input
    tz_clean = "".join([c for c in timezone_param if c.isalnum() or c in ['/', '_']]) if timezone_param else None

    tz_obj = None

    if isinstance(tz_clean, str):
        tz_clean = tz_clean.rstrip("/")
        if tz_clean.upper() == 'Z':
            tz_obj = timezone.utc
            tz_clean = None

    if tz_clean:
        try:
            tz_obj = ZoneInfo(tz_clean)
        except ZoneInfoNotFoundError:
            tz_obj = None

    if not tz_obj:
        tz_obj = datetime.now().astimezone().tzinfo

    datetime_now = datetime.now(tz=tz_obj)

    time_fmt = "%H:%M:%S"
    date_fmt = "%d.%m.%Y"

    # emulates linux date command
    date_now = datetime_now.strftime(date_fmt)
    time_now = datetime_now.strftime(time_fmt)
    timezone_now = tz_obj.tzname(datetime_now)

    date_data = {
        "date": date_now,
        "time": time_now,
        "timezone": timezone_now,
        "formats": {
            "date": date_fmt,
            "time": time_fmt,
        },
    }

    return jsonify(date_data)
