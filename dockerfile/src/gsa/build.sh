#!/usr/bin/env bash

STAGE="${1}"
[[ "${STAGE}" == "" ]] && STAGE="stable"

source "./${STAGE}"

git clone https://github.com/greenbone/gsa.git \
&& cd gsa \
&& git checkout ${CHECKOUT} \
&& mkdir -p build \
&& cd build \
&& cmake .. \
&& make -j$(($(nproc) + 1)) \
&& make install
