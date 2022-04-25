#!/usr/bin/env bash

# vars
GVM_ROOT="/var"
GSA_LOG_PATH="${GVM_ROOT}/log/gvm"

sudo mkdir -p "${GSA_LOG_PATH}"
sudo touch ${GSA_LOG_PATH}/gsad.log
sudo chown -R gvm. "${GSA_LOG_PATH}"

tail -f ${GSA_LOG_PATH}/gsad.log &

if [[ -z $@ ]]; then
  echo "gsad - starting..."
  sudo gsad -f -v --mport=${GVMD_PORT} --mlisten=${GVMD_ADDRESS} --listen=0.0.0.0
else
  exec "$@"
fi
