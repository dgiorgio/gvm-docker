#!/usr/bin/env bash

GVM_PATH="/usr/local/var/lib/gvm"

_CERT() {
  if [ ! -f "${GVM_PATH}/CA/clientcert.pem" ] || \
  [ ! -f "${GVM_PATH}/CA/cacert.pem" ] || \
  [ ! -f "${GVM_PATH}/private/CA/serverkey.pem" ] || \
  [ ! -f "${GVM_PATH}/CA/servercert.pem" ] || \
  [ ! -f "${GVM_PATH}/private/CA/clientkey.pem" ] || \
  [ ! -f "${GVM_PATH}/CA/clientcert.pem" ] ; then
    gvm-manage-certs -af
  fi
}

_GVM_MIGRATION() {
  gvmd -m
}

_ADMIN() {
  GVM_ADMIN="$(gvmd --get-users | grep -w admin)"
  if [ -z "${GVM_ADMIN}" ]; then
    gvmd --create-user=admin --role=Admin \
    && gvmd --user=admin --new-password=admin
  fi
}

_CERT
_GVM_MIGRATION
_ADMIN
