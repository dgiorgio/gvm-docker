#!/usr/bin/env bash

# DEBIAN - BUILD

# openvas-scanner

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
libglib2.0-dev
libgnutls28-dev
uuid-dev
libssh-gcrypt-dev
libpcap-dev
libksba-dev
bison
libsnmp-dev
libgpgme-dev
libhiredis-dev
bzip2
wget
rsync
nmap
"

# opt
OPT="
libldap2-dev
doxygen
xmltoman
libfreeradius-dev
"

# redis
OPT="${OPT}
redis-server
"

apt update -y && \
apt install -y --no-install-recommends --fix-missing ${BASE} ${DEPS} ${OPT}

# Remove packages
#apt remove -y ${BASE} ${DEPS} ${OPT}
apt autoremove -y
rm -rf /var/lib/apt/lists/*
