#!/usr/bin/env bash

feed_sync_nvt="1"
_PRINT() {
  COLOR='\033[0m'
  NC='\033[0m' # No Color
  [ "${1}" == "green" ] && COLOR='\033[0;32m'
  [ "${1}" == "yellow" ] && COLOR='\033[0;33m'
  [ "${1}" == "red" ] && COLOR='\033[0;31m'

  echo -e "${COLOR}${MSG}${NC}"
}

while [ "${feed_sync_nvt}" != "0" ]; do
  MSG="Update NVT - starting!!!" _PRINT "yellow"
  /usr/local/bin/gvm-nvt-sync.sh
  feed_sync_nvt="${?}"
  [ "${feed_sync_nvt}" == "0" ] && MSG="\nUpdate NVT - success!!! \n" _PRINT "green" \
  || MSG="\nUpdate NVTs - failed!!! \n" _PRINT "red"
  sleep 5
done
