#!/usr/bin/env bash

source /usr/local/bin/sshvpn_vars.sh
source /usr/local/bin/sshvpn_createlinks.sh
source /usr/local/bin/sshvpn_valid.sh

# autossh - hosts
# chmod +x "${SSHVPN_AUTOSSHDEST}/autossh-start.sh"
while true; do
  # update hosts
  cat "${SSHVPN_HOSTSDEST}/hosts" > /etc/hosts && \
  echo "$(date +%Y%m%dT%H%M%S) - /etc/hosts updated!"

  # start SSH-VPN
  "${SSHVPN_AUTOSSHDEST}/autossh-start.sh"
  sleep 1m
done
