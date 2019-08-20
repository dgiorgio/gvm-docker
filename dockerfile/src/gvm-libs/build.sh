#!/usr/bin/env bash

STAGE="${1}"
[[ "${STAGE}" == "" ]] && STAGE="stable"

source "./${STAGE}"

git clone https://github.com/greenbone/gvm-libs.git \
&& cd gvm-libs \
&& git reset --hard ${COMMIT} \
&& mkdir -p build \
&& cd build \
&& cmake .. \
&& make -j$(($(nproc) + 1)) \
&& make install
