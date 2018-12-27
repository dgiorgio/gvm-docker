# Install openvas-scanner
APP="openvas-scanner"
CHECKOUT="b1d4ca672f2ecb7c494789c60ba8fdeed1d6823c"

git clone https://github.com/greenbone/${APP}.git \
&& cd ${APP} \
&& git checkout ${CHECKOUT} . \
&& mkdir -p build \
&& cd build \
&& cmake .. \
&& make \
&& make install
