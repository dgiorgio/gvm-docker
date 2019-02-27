# Install openvas-smb
APP="openvas-smb"

STAGE="${1}"

[ "${STAGE}" == "stable" ] && CHECKOUT="tags/v1.0.4"
[ "${STAGE}" == "dev" ] && CHECKOUT="0de34e356127d8889dbf8d839a80976c3d124bf2"

git clone https://github.com/greenbone/${APP}.git \
&& cd ${APP} \
&& git checkout ${CHECKOUT} . \
&& mkdir -p build \
&& cd build \
&& cmake .. \
&& make \
&& make install
