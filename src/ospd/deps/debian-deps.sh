#!/usr/bin/env bash

# DEBIAN - BUILD

# ospd

# base
BASE="
git
"

# deps
DEPS="
python3
python3-setuptools
python-defusedxml
python3-paramiko
python3-defusedxml
python3-lxml
"

# opt
OPT="
"

apt update -y && \
DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends apt-utils && \
apt install -y --no-install-recommends --fix-missing ${BASE} ${DEPS} ${OPT}

# Remove packages
#apt remove -y ${BASE} ${DEPS} ${OPT}
apt autoremove -y
rm -rf /var/lib/apt/lists/*
