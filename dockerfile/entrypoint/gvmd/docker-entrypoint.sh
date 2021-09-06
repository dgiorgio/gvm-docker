#!/usr/bin/env bash

# vars
ENABLE_CRON="${ENABLE_CRON:-true}"
ENABLE_CRON="${ENABLE_CRON,,}"
GVM_UPDATE_CRON="${GVM_UPDATE_CRON:-0 */12 * * *}"

################################################################################
GVM_ROOT="/usr/local/var"
GVM_PATH="${GVM_ROOT}/lib/gvm"
GVM_LOG_PATH="${GVM_ROOT}/log/gvm"
SMTP_DMA_CONF_FILE="/etc/dma/dma.conf"
SMTP_DMA_AUTH_FILE="/etc/dma/auth.conf"
################################################################################
sudo mkdir -p "${GVM_PATH}" "${GVM_LOG_PATH}"
sudo chown -R gvm. "${GVM_ROOT}"

ln -sf /run/ospd/ospd.sock /tmp/ospd.sock

if [ ! -f "${GVM_PATH}/CA/clientcert.pem" ] || \
  [ ! -f "${GVM_PATH}/CA/cacert.pem" ] || \
  [ ! -f "${GVM_PATH}/private/CA/serverkey.pem" ] || \
  [ ! -f "${GVM_PATH}/CA/servercert.pem" ] || \
  [ ! -f "${GVM_PATH}/private/CA/clientkey.pem" ] || \
  [ ! -f "${GVM_PATH}/CA/clientcert.pem" ] ; then
  gvm-manage-certs -af
fi

POSTGRES_SOCK="/var/run/postgresql/.s.PGSQL.5432"
while [ ! -S "${POSTGRES_SOCK}" ]; do
  echo "File '${POSTGRES_SOCK}' not exist - Waiting for PostgreSQL to start"
  sleep 2
done

gvmd -m

sudo su - postgres -c "createuser -DRS gvm && createdb -O gvm -e gvmd"
sudo su - postgres -c "psql -d gvmd" << EOF
create role dba with superuser noinherit;
grant dba to gvm;
create extension "uuid-ossp";
create extension "pgcrypto";
EOF

GVM_ADMIN_CHECK="$(gvmd --get-users | grep -w admin)"
if [ -z "${GVM_ADMIN_CHECK}" ]; then
  GVM_ADMIN_PASSWORD="$(date +%s | sha256sum | base64 | head -c 50 ; echo)"
  echo "Creating the 'admin' user."
  gvmd --create-user=admin --role=Admin
  echo "Setting password for 'admin' user."
  gvmd --user=admin --new-password=${GVM_ADMIN_PASSWORD}
  echo "User 'admin' created, password: ${GVM_ADMIN_PASSWORD}"
fi

echo "Setting the Feed Import Owner - admin user"
gvmd --modify-setting 78eceaec-3385-11ea-b237-28d24461215b --value $(gvmd --get-users --verbose | grep admin | awk '{ print $2 }')

# sync feeds
/usr/local/bin/gvmd_feed_update.sh >> ${GVM_LOG_PATH}/gvmd_feed_update.log &

# cron - sync certdata/scapdata
if [ "${ENABLE_CRON}" != "false" ]; then
  CRON_FILE="/etc/cron.d/gvm"
  # Set default cron
  sudo touch "${CRON_FILE}"
  sudo chmod 0644 "${CRON_FILE}"
  echo "${GVM_UPDATE_CRON} gvm /usr/local/bin/gvmd_feed_update.sh >> ${GVM_LOG_PATH}/gvmd_feed_update.log" | sudo tee "${CRON_FILE}" > /dev/null
  sudo cron
  crontab "${CRON_FILE}"
fi

# apply SMTP template
echo "" | sudo tee "${SMTP_DMA_CONF_FILE}" > /dev/null # clean smtp config
echo "" | sudo tee "${SMTP_DMA_AUTH_FILE}" > /dev/null # clean smtp config
sudo chmod 640 "${SMTP_DMA_CONF_FILE}" "${SMTP_DMA_AUTH_FILE}"
j2 /etc/dma/dma.conf.j2 | grep -v '^$' | sudo tee -a "${SMTP_DMA_CONF_FILE}" > /dev/null
j2 /etc/dma/auth.conf.j2 | grep -v '^$' | sudo tee -a "${SMTP_DMA_AUTH_FILE}" > /dev/null

tail -f ${GVM_LOG_PATH}/*.log &
echo "gvmd - starting..."
exec "$@"
