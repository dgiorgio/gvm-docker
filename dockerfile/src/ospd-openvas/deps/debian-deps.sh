#!/usr/bin/env bash

# DEBIAN - BUILD

# ospd-openvas

# base
BASE="
git
"

# deps
DEPS="
python3
python3-redis
python3-dev
"

# opt
OPT="
"

apt update -y && \
apt install -y --no-install-recommends --fix-missing ${BASE} ${DEPS} ${OPT}

# Remove packages
#apt remove -y ${BASE} ${DEPS} ${OPT}
apt autoremove -y
rm -rf /var/lib/apt/lists/*
