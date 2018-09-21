#!/usr/bin/env bash

set -euo pipefail

PROJECT="greenbone"
COMPOSE="docker-compose"

_START() {
  "${COMPOSE}" -p "${PROJECT}" up --build -d
}

_START
