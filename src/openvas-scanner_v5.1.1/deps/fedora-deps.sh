#!/usr/bin/env bash

# DEBIAN - BUILD

# base
BASE="git"
# openvas-scanner - deps
DEPS="
cmake \
gcc \
glib2-devel \
gnutls-devel \
zlib-devel \
libuuid-devel \
libssh-devel \
hiredis-devel \
libgcrypt-devel \
bison \
gpgme-devel
"
# openvas-scanner - opt
OPT="
openldap-devel \
doxygen \
xmltoman \
freeradius-devel
"

dnf install -y ${BASE} ${DEPS} ${OPT}

# Remove packages
#apt remove -y ${BASE} ${DEPS} ${OPT}
dnf autoremove -y

