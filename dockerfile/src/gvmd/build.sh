#!/usr/bin/env bash

STAGE="${1}"
[[ "${STAGE}" == "" ]] && STAGE="stable"

source "./${STAGE}"

git clone https://github.com/greenbone/gvmd.git \
&& cd gvmd \
&& git reset --hard ${COMMIT} \
&& mkdir -p build \
&& cd build \
&& cmake .. \
&& make \
&& make install
