#!/usr/bin/env bash

CRON_FILE="/etc/cron.d/crontab"
GVM_SYNC="/usr/local/bin/gvm-sync.sh"
GVM_UPDATE_CRON_DEFAULT="0 */3 * * *"

touch "${CRON_FILE}"
chmod 0644 "${CRON_FILE}"

[ "${1}" == "true" ] && [ "${GVM_UPDATE_CRON}" == "" ] \
&& GVM_UPDATE_CRON="${GVM_UPDATE_CRON_DEFAULT}"

echo "${GVM_UPDATE_CRON} ${GVM_SYNC}" >> "${CRON_FILE}"
crontab /etc/cron.d/crontab \
&& cron
