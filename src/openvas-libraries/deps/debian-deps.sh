#!/usr/bin/env bash

# DEBIAN - BUILD

# gvm-libs

# base
BASE="
git
cmake
gcc
make
wget
"

# deps
DEPS="
pkg-config
libglib2.0-dev
libgnutls28-dev
uuid-dev
libssh-gcrypt-dev
libgpgme-dev
libhiredis-dev
libpcap-dev
libksba-dev
bison
"

# opt
OPT="
libldap2-dev
doxygen
xmltoman
libfreeradius-dev
"

apt update -y && \
apt install -y --no-install-recommends --fix-missing ${BASE} ${DEPS} ${OPT} && \
rm -rf /var/lib/apt/lists/*

# Remove packages
#apt remove -y ${BASE} ${DEPS} ${OPT}
apt autoremove -y
