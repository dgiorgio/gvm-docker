#!/usr/bin/env bash

# Start Redis server
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

# sync NVT
if [ "$(ls -A /usr/local/var/lib/openvas/plugins)" ]; then
  greenbone-nvt-sync --rsync
else
  greenbone-nvt-sync --wget
fi

# cron - sync NVT 
if [ "${ENABLE_CRON}" == "true" ] || [ "${ENABLE_CRON}" == "" ]; then
  CRON_FILE="/etc/cron.d/crontab"
  GVM_NVT_SYNC="/usr/local/bin/gvm-nvt-sync.sh"
  # Set default cron
  [ "${GVM_UPDATE_CRON}" == "" ] && GVM_UPDATE_CRON="0 */3 * * *"

  touch "${CRON_FILE}" && chmod 0644 "${CRON_FILE}"

  echo "${GVM_UPDATE_CRON} ${GVM_NVT_SYNC}" >> "${CRON_FILE}"
  crontab "${CRON_FILE}" && cron
fi

# Start openvas
echo "openvas - creating cache..."
/usr/local/sbin/openvassd -C >/dev/null 2>&1
echo "openvas - starting..."
exec "$@"
