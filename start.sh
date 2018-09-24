#!/usr/bin/env bash

set -euo pipefail

FILE="docker-compose.yml"
PROJECT="openvas"
COMPOSE="docker-compose"

_START() {
  "${COMPOSE}" -p "${PROJECT}" up --build -d --remove-orphans -f "${FILE}"
}

_START
