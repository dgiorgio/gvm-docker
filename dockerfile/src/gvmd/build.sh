#!/usr/bin/env bash

STAGE="${1}"
[[ "${STAGE}" == "" ]] && STAGE="stable"

source "./${STAGE}"

DATABASE="${2}"
[[ "${DATABASE}" == "sqlite" ]] || [[ "${DATABASE}" == "" ]] && CMAKE_OPT=""
[[ "${DATABASE}" == "postgres" ]] && CMAKE_OPT="-DBACKEND=POSTGRESQL"

git clone https://github.com/greenbone/gvmd.git \
&& cd gvmd \
&& git checkout ${CHECKOUT} \
&& mkdir -p build \
&& cd build \
&& cmake ${CMAKE_OPT} .. \
&& make \
&& make install
