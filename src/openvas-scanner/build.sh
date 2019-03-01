#!/usr/bin/env bash

# Install openvas-scanner
APP="openvas-scanner"

STAGE="${1}"

[[ ("${STAGE}" == "") || ("${STAGE}" == "stable") ]] && CHECKOUT="6a42e2f6ffcf5471a055cac8ccb2805387bd9638" # branch: openvas-scanner-6.0
[[ "${STAGE}" == "dev" ]] && CHECKOUT="95624657eebeab60c7e9aec38323d49227ff5ab1" # branch: master

git clone https://github.com/greenbone/${APP}.git \
&& cd ${APP} \
&& git checkout ${CHECKOUT} \
&& mkdir -p build \
&& cd build \
&& cmake .. \
&& make \
&& make install
