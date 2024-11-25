#!/bin/sh

python manage.py collectstatic

gunicorn --bind 0.0.0.0:5001 algebra_api.wsgi
