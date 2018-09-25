#!/bin/sh
set -e

echo "services don't auto start in container, force start them"
for SERV in nginx rsyslog supervisor ; do
    sudo service $SERV start
done

echo "sending test message to rsyslog to make sure app logfile exists"
logger -t supervisord hello from docker entry script

exec "$@"