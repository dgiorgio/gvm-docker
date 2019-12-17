#!/usr/bin/env bash

STAGE="${1}"
[[ "${STAGE}" == "" ]] && STAGE="stable"

source "./${STAGE}"

git clone https://github.com/greenbone/ospd.git \
&& cd ospd \
&& git reset --hard ${COMMIT} \
&& python3 setup.py install
