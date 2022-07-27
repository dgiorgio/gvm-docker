#!/usr/bin/env bash

# vars
ENABLE_CRON="${ENABLE_CRON:-true}"
ENABLE_CRON="${ENABLE_CRON,,}"
GVM_UPDATE_CRON="${GVM_UPDATE_CRON:-0 */12 * * *}"

################################################################################
GVM_ROOT="/var"
GVM_PATH="${GVM_ROOT}/lib/gvm"
GVM_LOG_PATH="${GVM_ROOT}/log/gvm"
OPENVAS_LIB_PATH="${GVM_ROOT}/lib/openvas"
OPENVAS_CONF_PATH="/etc/openvas"
OSDP_RUN_PATH="/var/run/ospd"
################################################################################
sudo mkdir -p "${GVM_PATH}" "${GVM_LOG_PATH}" "${OPENVAS_LIB_PATH}" "${OSDP_RUN_PATH}" "${OPENVAS_CONF_PATH}"
sudo chown -R gvm. "${GVM_PATH}" "${GVM_LOG_PATH}" "${OPENVAS_LIB_PATH}" "${OSDP_RUN_PATH}" "${OPENVAS_CONF_PATH}"

sudo ldconfig

if [[ -z $@ ]]; then
  echo "Testing redis status..."
  while [ ! -S "/var/run/redis/redis.sock" ]; do
    echo "Redis not yet ready, /var/run/redis/redis.sock not exists."
    sleep 1
  done
  sudo chown gvm. /var/run/redis/redis.sock
  echo "Redis ready."

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

  rm -f ${OSDP_RUN_PATH}/ospd.pid
  rm -f ${OSDP_RUN_PATH}/ospd-openvas.pid

  rm -rf /etc/openvas/gnupg
  ln -sf ${GVM_PATH}/gvmd/gnupg /etc/openvas/gnupg
  # Start openvas
  echo "openvas - starting..."
  ospd-openvas -f --lock-file-dir ${OSDP_RUN_PATH} --pid-file ${OSDP_RUN_PATH}/ospd.pid --unix-socket ${OSDP_RUN_PATH}/ospd.sock -m 0777 --key-file ${GVM_PATH}/private/CA/serverkey.pem --cert-file ${GVM_PATH}/CA/servercert.pem --ca-file ${GVM_PATH}/CA/cacert.pem -L DEBUG
else
  exec "$@"
fi
