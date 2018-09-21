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

if [ ! -z "/usr/local/var/lib/openvas/plugins" ]; then
  /usr/local/sbin/greenbone-nvt-sync --rsync
else
  /usr/local/sbin/greenbone-nvt-sync --wget
fi

>> /usr/local/var/log/openvas/openvassd.messages
tail -f /usr/local/var/log/openvas/* &
echo "openvas-scanner - creating cache..."
/usr/local/sbin/openvassd -C >/dev/null 2>&1
echo "openvas-scanner - starting..."
/usr/local/sbin/openvassd -f
