#!/usr/bin/env bash

ENABLE_CRON_DEFAULT="true"
[ "${ENABLE_CRON}" != "true" ] && ENABLE_CRON="${ENABLE_CRON_DEFAULT}"

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
/usr/local/bin/greenbone-sync.sh
/usr/local/bin/greenbone-cron.sh "${ENABLE_CRON}"

>> /usr/local/var/log/gvm/openvassd.log
>> /usr/local/var/log/gvm/gsad.log
>> /usr/local/var/log/gvm/gvmd.log

echo "openvas-scanner - creating cache..."
/usr/local/sbin/openvassd -C >/dev/null 2>&1
echo "openvas-scanner - starting..."
/usr/local/sbin/openvassd
sleep 10

gvmd -v --listen=0.0.0.0 --port=9390

gsad -v --mlisten=127.0.0.1 --mport=9390 --listen=0.0.0.0

tail -f /usr/local/var/log/gvm/*
