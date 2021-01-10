#!/usr/bin/env bash

GVM_PATH="/usr/local/var/lib/gvm"

sudo mkdir -p "${GVM_PATH}"
sudo chown -R gvm. "/usr/local/var"

ln -sf /run/ospd/ospd.sock /tmp/ospd.sock

if [ ! -f "${GVM_PATH}/CA/clientcert.pem" ] || \
  [ ! -f "${GVM_PATH}/CA/cacert.pem" ] || \
  [ ! -f "${GVM_PATH}/private/CA/serverkey.pem" ] || \
  [ ! -f "${GVM_PATH}/CA/servercert.pem" ] || \
  [ ! -f "${GVM_PATH}/private/CA/clientkey.pem" ] || \
  [ ! -f "${GVM_PATH}/CA/clientcert.pem" ] ; then
  gvm-manage-certs -af
fi

while [ ! -S "/var/run/postgresql/.s.PGSQL.5432" ]; do
  echo "File '/var/run/postgresql/.s.PGSQL.5432' not exist - Waiting for PostgreSQL to start"
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

echo "Update GVMD_DATA"
greenbone-feed-sync --type GVMD_DATA
sleep 5

echo "Update SCAP"
greenbone-feed-sync --type SCAP
sleep 5

echo "Update CERT"
greenbone-feed-sync --type CERT

# cron - sync certdata/scapdata
function _cron(){
  if [ "${ENABLE_CRON}" == "true" ] || [ "${ENABLE_CRON}" == "" ]; then
    CRON_FILE="/etc/cron.d/crontab"
    # Set default cron
    [ "${GVM_UPDATE_CRON}" == "" ] && GVM_UPDATE_CRON="0 */3 * * *"

    touch "${CRON_FILE}" && chmod 0644 "${CRON_FILE}"

    echo "${GVM_UPDATE_CRON} greenbone-certdata-sync" > "${CRON_FILE}"
    echo "${GVM_UPDATE_CRON} greenbone-scapdata-sync" >> "${CRON_FILE}"
    crontab "${CRON_FILE}" && cron
  fi
}
FUNC="$(declare -f _cron)"
sudo bash -c "${FUNC}; _cron"

tail -f /usr/local/var/log/gvm/gvmd.log &
echo "gvmd - starting..."
exec "$@"
