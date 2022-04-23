#!/usr/bin/env bash

# vars
ENABLE_CRON="${ENABLE_CRON:-true}"
ENABLE_CRON="${ENABLE_CRON,,}"
GVM_UPDATE_CRON="${GVM_UPDATE_CRON:-0 */12 * * *}"

################################################################################
GVM_ROOT="/var"
GVM_PATH="${GVM_ROOT}/lib/gvm"
GVM_LOG_PATH="${GVM_ROOT}/log/gvm"
################################################################################
sudo mkdir -p "${GVM_PATH}" "${GVM_LOG_PATH}"
sudo chown -R gvm. "${GVM_ROOT}"

sudo ldconfig

echo "Testing redis status..."
while [ ! -S "/var/run/redis/redis.sock" ]; do
  echo "Redis not yet ready, /run/redis/redis.sock not exists."
  sleep 1
done
sudo chown gvm. /run/redis/redis.sock
echo "Redis ready."

sudo mkdir -p ${GVM_ROOT}/lib/openvas /var/run/ospd \
&& sudo chown -R gvm. ${GVM_ROOT} /var/run/ospd

# cron - sync NVT
if [ "${ENABLE_CRON}" != "false" ]; then
  CRON_FILE="/etc/cron.d/gvm"
  # Set default cron
  sudo touch "${CRON_FILE}"
  sudo chmod 0644 "${CRON_FILE}"
  printenv | grep -e "^PATH=\|RSYNC_FEED" | sudo tee "${CRON_FILE}" > /dev/null
  echo "${GVM_UPDATE_CRON} gvm flock --verbose -n /tmp/nvt_feed_update.lockfile /usr/local/bin/nvt_feed_update.sh >> ${GVM_LOG_PATH}/nvt_feed_update.log 2>&1" | sudo tee -a "${CRON_FILE}" > /dev/null
  sudo cron
fi

# sync NVT
touch "${GVM_LOG_PATH}/nvt_feed_update.log"
tail -f ${GVM_LOG_PATH}/*.log &
flock --verbose -n /tmp/nvt_feed_update.lockfile /usr/local/bin/nvt_feed_update.sh >> ${GVM_LOG_PATH}/nvt_feed_update.log 2>&1 &

if [[ -z $@ ]]; then
  rm -f /var/run/ospd/ospd.pid
  # Start openvas
  echo "openvas - Updates VT info into redis store from VT files"
  openvas -u
  echo "openvas - starting..."
  ospd-openvas -f --pid-file /var/run/ospd/ospd.pid --unix-socket /var/run/ospd/ospd.sock -m 0777 --key-file /usr/local/var/lib/gvm/private/CA/serverkey.pem --cert-file /usr/local/var/lib/gvm/CA/servercert.pem --ca-file /usr/local/var/lib/gvm/CA/cacert.pem -L DEBUG
else
  exec "$@"
fi
