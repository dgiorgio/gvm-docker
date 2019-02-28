#!/usr/bin/env bash

# DEBIAN - BUILD

# openvas-smb

# base
BASE="
git
gcc
cmake
make
pkg-config
"

# deps
DEPS="
pkg-config
gcc-mingw-w64
perl-base
heimdal-dev
libpopt-dev
libglib2.0-dev
libgnutls28-dev
"

# opt
OPT="
xmltoman
doxygen
"

apt update -y && \
apt install -y --no-install-recommends --fix-missing ${BASE} ${DEPS} ${OPT} && \
rm -rf /var/lib/apt/lists/*

# Remove packages
#apt remove -y ${BASE} ${DEPS} ${OPT}
apt autoremove -y
