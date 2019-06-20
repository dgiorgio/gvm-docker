#!/usr/bin/env bash

CRON_FILE="/etc/cron.d/crontab"
GREENBONE_SYNC="/usr/local/bin/greenbone-sync.sh"
GREENBONE_UPDATE_CRON_DEFAULT="0 23 * * *"

touch "${CRON_FILE}"
chmod 0644 "${CRON_FILE}"

[ "${1}" == "true" ] && [ "${GREENBONE_UPDATE_CRON}" == "" ] \
&& GREENBONE_UPDATE_CRON="${GREENBONE_UPDATE_CRON_DEFAULT}"

echo "${GREENBONE_UPDATE_CRON} ${GREENBONE_SYNC}" >> "${CRON_FILE}"
crontab /etc/cron.d/crontab \
&& cron
