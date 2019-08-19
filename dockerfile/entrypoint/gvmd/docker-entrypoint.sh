#!/usr/bin/env bash

GVM_PATH="/usr/local/var/lib/gvm"

if [ ! -f "${GVM_PATH}/CA/clientcert.pem" ] || \
[ ! -f "${GVM_PATH}/CA/cacert.pem" ] || \
[ ! -f "${GVM_PATH}/private/CA/serverkey.pem" ] || \
[ ! -f "${GVM_PATH}/CA/servercert.pem" ] || \
[ ! -f "${GVM_PATH}/private/CA/clientkey.pem" ] || \
[ ! -f "${GVM_PATH}/CA/clientcert.pem" ] ; then
  gvm-manage-certs -af
fi

gvmd -m

GVM_ADMIN="$(gvmd --get-users | grep -w admin)"
if [ -z "${GVM_ADMIN}" ]; then
  gvmd --create-user=admin --role=Admin \
  && gvmd --user=admin --new-password=admin
  echo '
Create default user
  login: admin
  password: admin
  role: Admin
'
fi

while [ -f '/usr/local/var/run/openvassd.sock' ]; do
  echo "'/usr/local/var/run/openvassd.sock' not found, openvas not yet ready..."
  sleep 1
done

sleep 15
echo "run greenbone-certdata-sync"
greenbone-certdata-sync
sleep 15
echo "run greenbone-scapdata-sync"
greenbone-scapdata-sync

# cron - sync certdata/scapdata
if [ "${ENABLE_CRON}" == "true" ] || [ "${ENABLE_CRON}" == "" ]; then
  CRON_FILE="/etc/cron.d/crontab"
  # Set default cron
  [ "${GVM_UPDATE_CRON}" == "" ] && GVM_UPDATE_CRON="0 */3 * * *"

  touch "${CRON_FILE}" && chmod 0644 "${CRON_FILE}"

  echo "${GVM_UPDATE_CRON} greenbone-certdata-sync" >> "${CRON_FILE}"
  echo "${GVM_UPDATE_CRON} greenbone-scapdata-sync" >> "${CRON_FILE}"
  crontab "${CRON_FILE}" && cron
fi

tail -f /usr/local/var/log/gvm/gvmd.log &
echo "gvmd - starting..."
exec "$@"
