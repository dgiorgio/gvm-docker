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

/usr/local/sbin/gvmd -m

sudo su - postgres -c "createuser -DRS gvm && createdb -O gvm -e gvmd"
sudo su - postgres -c "psql -d gvmd" << EOF
create role dba with superuser noinherit;
grant dba to gvm;
create extension "uuid-ossp";
create extension "pgcrypto";
EOF

GVM_ADMIN_PASSWORD="$(date +%s | sha256sum | base64 | head -c 50 ; echo)"
GVM_ADMIN_CHECK="$(/usr/local/sbin/gvmd --get-users | grep -w admin)"
if [ -z "${GVM_ADMIN_CHECK}" ]; then
  echo "Creating the 'admin' user."
  /usr/local/sbin/gvmd --create-user=admin --role=Admin
  echo "Setting password for 'admin' user."
  /usr/local/sbin/gvmd --user=admin --new-password=${GVM_ADMIN_PASSWORD}
  echo "User 'admin' created, password: ${GVM_ADMIN_PASSWORD}"
fi

echo "run greenbone-certdata-sync"
greenbone-certdata-sync
echo "run greenbone-scapdata-sync"
greenbone-scapdata-sync

# cron - sync certdata/scapdata
function _cron(){
  if [ "${ENABLE_CRON}" == "true" ] || [ "${ENABLE_CRON}" == "" ]; then
    CRON_FILE="/etc/cron.d/crontab"
    # Set default cron
    [ "${GVM_UPDATE_CRON}" == "" ] && GVM_UPDATE_CRON="0 */3 * * *"

    touch "${CRON_FILE}" && chmod 0644 "${CRON_FILE}"

    echo "${GVM_UPDATE_CRON} greenbone-certdata-sync" >> "${CRON_FILE}"
    echo "${GVM_UPDATE_CRON} greenbone-scapdata-sync" >> "${CRON_FILE}"
    crontab "${CRON_FILE}" && cron
  fi
}
FUNC="$(declare -f _cron)"
sudo bash -c "${FUNC}; _cron"

tail -f /usr/local/var/log/gvm/gvmd.log &
echo "gvmd - starting..."
exec "$@"
