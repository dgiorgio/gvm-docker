#!/usr/bin/env bash

sudo rm -rf /var/run/ospd/ospd.pid
sudo rm -rf /var/run/ospd/ospd.sock
sudo chown -R gvm. /etc/redis.conf

# Start Redis server
sudo ldconfig
/usr/bin/redis-server /etc/redis.conf --daemonize yes \
&& sudo chown -R gvm. /run/redis/redis.sock

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

sudo mkdir -p /usr/local/var/lib/openvas /var/run/ospd \
&& sudo chown -R gvm. /usr/local/var /var/run/ospd

# sync NVT
/usr/local/bin/gvm-nvt-sync.sh

# cron - sync NVT
function _cron(){
if [ "${ENABLE_CRON}" == "true" ] || [ "${ENABLE_CRON}" == "" ]; then
  CRON_FILE="/etc/cron.d/crontab"
  GVM_NVT_SYNC="/usr/local/bin/gvm-nvt-sync.sh"
  # Set default cron
  [ "${GVM_UPDATE_CRON}" == "" ] && GVM_UPDATE_CRON="0 */3 * * *"

  touch "${CRON_FILE}" && chmod 0644 "${CRON_FILE}"

  echo "${GVM_UPDATE_CRON} ${GVM_NVT_SYNC}" >> "${CRON_FILE}"
  crontab "${CRON_FILE}" && cron
fi
}
FUNC="$(declare -f _cron)"
sudo bash -c "${FUNC}; _cron"

# Start openvas
echo "openvas - Updates VT info into redis store from VT files"
/usr/local/sbin/openvas -u
echo "openvas - starting..."
exec "$@"
