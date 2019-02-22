# Install openvas-scanner
APP="openvas-scanner"
CHECKOUT="3e87367e6994da94530ef28baee88ca87ef885c6"

git clone https://github.com/greenbone/${APP}.git \
&& cd ${APP} \
&& git checkout ${CHECKOUT} . \
&& mkdir -p build \
&& cd build \
&& cmake .. \
&& make \
&& make install
