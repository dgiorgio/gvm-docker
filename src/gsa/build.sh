#!/usr/bin/env bash

# Install gsa
APP="gsa"

STAGE="${1}"

[[ ("${STAGE}" == "") || ("${STAGE}" == "stable") ]] && CHECKOUT="e9b5480cfeefed104fc23ca0e92b4ecfc170493b" # branch: gsa-8.0
[[ "${STAGE}" == "dev" ]] && CHECKOUT="4d71cc1898c49c386f7c74f2661587f358a36236" # branch: master

git clone https://github.com/greenbone/${APP}.git \
&& cd ${APP} \
&& git checkout ${CHECKOUT} \
&& mkdir -p build \
&& cd build \
&& cmake .. \
&& make \
&& make install
