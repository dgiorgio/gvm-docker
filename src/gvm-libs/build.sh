# Install gvm-libs
APP="gvm-libs"
CHECKOUT="7fecb224078e01cd091e3afb4e071bcf77ae43b7"

git clone https://github.com/greenbone/${APP}.git \
&& cd ${APP} \
&& git checkout ${CHECKOUT} . \
&& mkdir -p build \
&& cd build \
&& cmake .. \
&& make \
&& make install
