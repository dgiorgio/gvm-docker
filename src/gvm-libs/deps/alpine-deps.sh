
# ALPINE - BUILD

# base
BASE="git"
# openvas-scanner - deps
DEPS="
cmake \
make \
gcc \
g++ \
glib-dev \
gnutls-dev \
libssh-dev \
gpgme-dev \
hiredis-dev \
libgcrypt-dev
"

# openvas-scanner - opt
OPT="
openldap-dev \
doxygen \
xmltoman \
freeradius-dev
"

# base
apk add --no-cache ${BASE} ${DEPS} ${OPT}

# Remove packages
#apk del ${BASE} ${DEPS} ${OPT}
