#!/usr/bin/env bash

set -euo pipefail

FILES=""
PARAMETER="${@}"

if [ "${PARAMETER}" == "" ]; then
  FILES="-f docker-compose.yml"
else
  for i in ${PARAMETER}; do
    FILES="${FILES} -f ${i}"
  done
fi

PROJECT="openvas"
COMPOSE="docker-compose"

"${COMPOSE}" ${FILES} -p "${PROJECT}" up --build -d
