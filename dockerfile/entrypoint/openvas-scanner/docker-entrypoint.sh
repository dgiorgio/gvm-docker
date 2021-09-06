#!/usr/bin/env bash

sudo rm -rf /var/run/ospd/ospd.pid
sudo rm -rf /var/run/ospd/ospd.sock

sudo ldconfig

echo "Testing redis status..."
while [ ! -S "/var/run/redis/redis.sock" ]; do
  echo "Redis not yet ready, /run/redis/redis.sock not exists."
  sleep 1
done
sudo chown gvm. /run/redis/redis.sock
echo "Redis ready."

sudo mkdir -p /usr/local/var/lib/openvas /var/run/ospd \
&& sudo chown -R gvm. /usr/local/var /var/run/ospd

# sync NVT
/usr/local/bin/nvt_feed_update.sh &

# cron - sync NVT
function _cron(){
if [ "${ENABLE_CRON}" == "true" ] || [ "${ENABLE_CRON}" == "" ]; then
  CRON_FILE="/etc/cron.d/crontab"
  NVT_SYNC="/usr/local/bin/nvt_feed_update.sh"
  # Set default cron
  [ "${GVM_UPDATE_CRON}" == "" ] && GVM_UPDATE_CRON="0 */3 * * *"
  touch "${CRON_FILE}" && chmod 0644 "${CRON_FILE}"
  echo "${GVM_UPDATE_CRON} ${NVT_SYNC}" > "${CRON_FILE}"
  crontab "${CRON_FILE}" && cron
fi
}
FUNC="$(declare -f _cron)"
sudo bash -c "${FUNC}; _cron"

# Start openvas
echo "openvas - Updates VT info into redis store from VT files"
openvas -u
echo "openvas - starting..."
exec "$@"
