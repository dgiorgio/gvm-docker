# Install openvas-scanner
APP="openvas-scanner"

STAGE="${1}"

[ "${STAGE}" == "stable" ] && CHECKOUT="openvas-scanner-6.0"
[ "${STAGE}" == "dev" ] && CHECKOUT="9da86e8367ad8b548fdd51314b77309f5b3b6491"

git clone https://github.com/greenbone/${APP}.git \
&& cd ${APP} \
&& git checkout ${CHECKOUT} . \
&& mkdir -p build \
&& cd build \
&& cmake .. \
&& make \
&& make install
