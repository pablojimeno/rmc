#!/bin/bash

# Runs the production server. Should be ran as a daemon.
# Args:
#   $1: name of pidfile

# Bail on errors
set -e

cd /home/rmc

echo "Installing requirements"
sudo pip install -r rmc/requirements.txt

echo "Recompiling compass"
compass clean rmc/server/static/
compass compile rmc/server/static/

# Start the uwsgi server
# TODO(david): Benchmark with ab and use worker processes if necessary
uwsgi --socket /tmp/uwsgi.sock \
  --chmod-socket 666 \
  --wsgi rmc.server.server:app \
  --master \
  --daemonize /home/rmc/logs/uwsgi.log \
  --pidfile $1