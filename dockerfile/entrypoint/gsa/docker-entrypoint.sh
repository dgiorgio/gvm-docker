#!/usr/bin/env bash

mkdir -p /usr/local/var/log/gvm
touch /usr/local/var/log/gvm/gsad.log

tail -f /usr/local/var/log/gvm/gsad.log &
echo "gsad - starting..."
gsad -f -v --mport=${GVMD_PORT} --mlisten=${GVMD_ADDRESS} --listen=0.0.0.0
