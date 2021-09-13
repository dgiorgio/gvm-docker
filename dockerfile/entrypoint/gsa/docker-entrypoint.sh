#!/usr/bin/env bash

# vars
GVM_ROOT="/usr/local/var"

sudo mkdir -p ${GVM_ROOT}/log/gvm
sudo touch ${GVM_ROOT}/log/gvm/gsad.log
sudo chown -R gvm. "${GVM_ROOT}"

tail -f ${GVM_ROOT}/log/gvm/gsad.log &
echo "gsad - starting..."
sudo gsad -f -v --mport=${GVMD_PORT} --mlisten=${GVMD_ADDRESS} --listen=0.0.0.0
