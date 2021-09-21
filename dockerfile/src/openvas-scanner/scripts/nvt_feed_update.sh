#!/usr/bin/env bash

### feed_sync_nvt_status
# 0 - success
# 1 - start process
# 2 - failed
feed_sync_nvt_status_file="/usr/local/var/lib/openvas/feed_sync_nvt_status"
touch "${feed_sync_nvt_status_file}"

_PRINT() {
  COLOR='\033[0m'
  NC='\033[0m' # No Color
  [ "${1}" == "green" ] && COLOR='\033[0;32m'
  [ "${1}" == "yellow" ] && COLOR='\033[0;33m'
  [ "${1}" == "red" ] && COLOR='\033[0;31m'

  echo -e "${COLOR}${MSG}${NC}"
}

feed_sync_nvt="1" # force start loop
while [ "${feed_sync_nvt}" != "0" ]; do
  MSG="Update NVT - starting!!!" _PRINT "yellow"
  echo "1" > "${feed_sync_nvt_status_file}"
  # /usr/local/bin/gvm-nvt-sync.sh
  greenbone-nvt-sync -v
  feed_sync_nvt="${?}"

  if [ "${feed_sync_nvt}" == "0" ]; then
    MSG="\nUpdate NVT - success!!! \n" _PRINT "green"
    echo "0" > "${feed_sync_nvt_status_file}"
  else
    MSG="\nUpdate NVTs - failed!!! \n" _PRINT "red"
    echo "2" > "${feed_sync_nvt_status_file}"
    sleep 5
  fi
done
