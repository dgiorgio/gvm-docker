#!/usr/bin/env bash

set -euo pipefail

APP="${1}"
SO="${2}"
VERSION="${3}"

docker build --compress -t "dgiorgio/${APP}:${SO}-${VERSION}" -f "Dockerfile-${APP}.${SO}" .
