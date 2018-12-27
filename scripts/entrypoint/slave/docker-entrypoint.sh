#!/usr/bin/env bash

ldconfig

/usr/bin/redis-server /etc/redis.conf --daemonize yes

_REDIS-CHECK() {
  REDIS_RESULT="$(/usr/bin/redis-cli ping)"
}

echo "Testing redis status..."
_REDIS-CHECK

while [ "${REDIS_RESULT}" != "PONG" ]; do
  echo "Redis not yet ready..."
  sleep 1
  _REDIS-CHECK
done
echo "Redis ready."

/usr/local/bin/greenbone-setup.sh

>> /usr/local/var/log/gvm/openvassd.log

echo "openvas-scanner - creating cache..."
/usr/local/sbin/openvassd -C >/dev/null 2>&1
echo "openvas-scanner - starting..."
/usr/local/sbin/openvassd
sleep 10

gvmd -v --listen=0.0.0.0 --port=9390

tail -f /usr/local/var/log/gvm/*
