# -*- encoding: utf-8 -*-
"""
License: MIT
Copyright (c) 2019 - present AppSeed.us
"""

from flask_migrate import Migrate
from os import environ
from sys import exit

from config import config_dict
from app import create_app, db

get_config_mode = environ.get('APPSEED_CONFIG_MODE', 'Debug')

try:
    config_mode = config_dict[get_config_mode.capitalize()]
except KeyError:
    exit('Error: Invalid APPSEED_CONFIG_MODE environment variable entry.')

app = create_app(config_mode) 
Migrate(app, db)

if __name__ == "__main__":
    app.run()

# live-reload is not used in production, but can be useful during development.
# if __name__ == "__main__":
#     server = Server(app.wsgi_app)
#     # server.watch(...)
#     server.serve(port=2200)