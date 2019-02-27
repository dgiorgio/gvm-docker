# Install openvas-scanner
APP="openvas-scanner"

VERSION="${1}"

[ "${VERSION}" == "release" ] && CHECKOUT="openvas-scanner-6.0"
[ "${VERSION}" == "dev" ] && CHECKOUT="9da86e8367ad8b548fdd51314b77309f5b3b6491"

git clone https://github.com/greenbone/${APP}.git \
&& cd ${APP} \
&& git checkout ${CHECKOUT} . \
&& mkdir -p build \
&& cd build \
&& cmake .. \
&& make \
&& make install
