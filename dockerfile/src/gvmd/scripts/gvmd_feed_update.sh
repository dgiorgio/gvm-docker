#!/usr/bin/env bash

feed_sync_gvmd_data="1"
feed_sync_scap="1"
feed_sync_cert="1"

_PRINT() {
  COLOR='\033[0m'
  NC='\033[0m' # No Color
  [ "${1}" == "green" ] && COLOR='\033[0;32m'
  [ "${1}" == "yellow" ] && COLOR='\033[0;33m'
  [ "${1}" == "red" ] && COLOR='\033[0;31m'

  echo -e "${COLOR}${MSG}${NC}"
}

_update_gvmd_data(){
  MSG="Update GVMD_DATA - starting!!!" _PRINT "yellow"
  greenbone-feed-sync --type GVMD_DATA
  feed_sync_gvmd_data="${?}"
  [ "${feed_sync_gvmd_data}" == "0" ] && MSG="Update GVMD_DATA - success!!! \n" _PRINT "green" \
  || MSG="Update GVMD_DATA - failed!!! \n" _PRINT "red"
}

_update_scap(){
  MSG="Update SCAP - starting!!!" _PRINT "yellow"
  greenbone-feed-sync --type SCAP
  feed_sync_scap="${?}"
  [ "${feed_sync_scap}" == "0" ] && MSG="Update SCAP - success!!! \n" _PRINT "green" \
  || MSG="Update SCAP - failed!!! \n" _PRINT "red"
}

_update_cert(){
  MSG="Update CERT - starting!!!" _PRINT "yellow"
  greenbone-feed-sync --type CERT
  feed_sync_cert="${?}"
  [ "${feed_sync_cert}" == "0" ] && MSG="Update CERT - success!!! \n" _PRINT "green" \
  || MSG="Update CERT - failed!!! \n" _PRINT "red"
}

while [ "${feed_sync_gvmd_data}" != "0" ] || [ "${feed_sync_scap}" != "0" ] || [ "${feed_sync_cert}" != "0" ]; do
  [ "${feed_sync_gvmd_data}" == "0" ] || _update_gvmd_data
  [ "${feed_sync_scap}" == "0" ] || _update_scap
  [ "${feed_sync_cert}" == "0" ] || _update_cert
  sleep 5
done
