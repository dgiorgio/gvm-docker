# Install gvm-libs
APP="gvm-libs"
CHECKOUT="61ae9c01880fe120ad6f49c73c588a6c3927858f"

git clone https://github.com/greenbone/${APP}.git \
&& cd ${APP} \
&& git checkout ${CHECKOUT} . \
&& mkdir -p build \
&& cd build \
&& cmake .. \
&& make \
&& make install
