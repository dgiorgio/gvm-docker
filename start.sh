#!/usr/bin/env bash

set -euo pipefail

FILE="docker-compose.yml"
PROJECT="openvas"
COMPOSE="docker-compose"

_START() {
  "${COMPOSE}" -f "${FILE}" -p "${PROJECT}" up --build -d --remove-orphans
}

_START
