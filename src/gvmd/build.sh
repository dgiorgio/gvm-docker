# Install gvm
APP="gvmd"

STAGE="${1}"

[ "${STAGE}" == "stable" ] && CHECKOUT="gvmd-8-0"
[ "${STAGE}" == "dev" ] && CHECKOUT="b6d078e6d2da0b3eb95a415ad34ca392b394f043"

git clone https://github.com/greenbone/${APP}.git \
&& cd ${APP} \
&& git checkout ${CHECKOUT} . \
&& mkdir -p build \
&& cd build \
&& cmake .. \
&& make \
&& make install
