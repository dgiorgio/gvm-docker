
# ALPINE - BUILD

# base
BASE="git"
# openvas - deps
DEPS="
cmake \
make \
gcc \
g++ \
glib-dev \
gnutls-dev \
libssh-dev \
gpgme-dev \
libgcrypt-dev \
libpcap-dev \
libksba-dev \
bison
"

# openvas - opt
OPT="
openldap-dev \
doxygen \
xmltoman \
freeradius-dev
"

# # heimdal
# OPT="
# ${OPT}
# libtool
# automake
# autoconf
# perl-json
# ncurses-dev
# "

# base
apk add --no-cache ${BASE} ${DEPS} ${OPT}

# # heimdal
# git clone https://github.com/heimdal/heimdal.git && \
# cd heimdal && \
# git checkout -b heimdal-7-1-branch origin/heimdal-7-1-branch && \
# autoreconf -f -i && \
# ./configure && \
# make && \
# make install

# Remove packages
#apk del ${BASE} ${DEPS} ${OPT}
