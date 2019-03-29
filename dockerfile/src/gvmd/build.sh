#!/usr/bin/env bash

# Install gvm
APP="gvmd"

STAGE="${1}"
[[ "${STAGE}" == "" ]] && STAGE="stable"

source "./${STAGE}"

DATABASE="${2}"
[[ "${DATABASE}" == "" ]] && DATABASE="sqlite"
[[ "${DATABASE}" == "postgres" ]] && CMAKE_OPT="-DBACKEND=POSTGRESQL"
[[ "${DATABASE}" == "sqlite" ]] && CMAKE_OPT=""

git clone https://github.com/greenbone/${APP}.git \
&& cd ${APP} \
&& git checkout ${CHECKOUT} \
&& mkdir -p build \
&& cd build \
&& cmake ${CMAKE_OPT} .. \
&& make \
&& make install
