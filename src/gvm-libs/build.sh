#!/usr/bin/env bash

# Install gvm-libs
APP="gvm-libs"

STAGE="${1}"

[[ "${STAGE}" == "stable" ]] && CHECKOUT="5370a7d60e2adc4d65f94ad00e6cf4b572e3aa23" # branch: gvm-libs-1.0
[[ "${STAGE}" == "dev" ]] && CHECKOUT="61ae9c01880fe120ad6f49c73c588a6c3927858f" # branch: master

git clone https://github.com/greenbone/${APP}.git \
&& cd ${APP} \
&& git checkout ${CHECKOUT} \
&& mkdir -p build \
&& cd build \
&& cmake .. \
&& make \
&& make install
