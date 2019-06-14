#!/usr/bin/env bash

# DEBIAN - BUILD

# gsa

# base
BASE="
git
cmake
gcc
make
pkg-config
"
# nodejs
BASE="${BASE} curl apt-transport-https"

# deps
DEPS="
libglib2.0-dev
libgnutls28-dev
libmicrohttpd-dev
gettext
python-polib
libxml2-dev
"

# opt
OPT="
doxygen
xmltoman
ssh
texlive-latex-extra
texlive-fonts-recommended
"

apt update -y && \
apt install -y --no-install-recommends --fix-missing ${BASE} ${DEPS} ${OPT}

# yarn
curl --silent --show-error https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add -
echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list
# nodejs
curl --silent --show-error https://deb.nodesource.com/gpgkey/nodesource.gpg.key | apt-key add -
echo "deb https://deb.nodesource.com/node_8.x stretch main" | tee /etc/apt/sources.list.d/nodesource.list
apt update -y
apt install -y nodejs yarn

# Remove packages
#apt remove -y ${BASE} ${DEPS} ${OPT}
apt autoremove -y
rm -rf /var/lib/apt/lists/*
