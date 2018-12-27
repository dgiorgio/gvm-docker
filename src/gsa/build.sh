# Install gsa
APP="gsa"
CHECKOUT="99123d7639852bf1c078f0d3522b854cb389d0c3"

git clone https://github.com/greenbone/${APP}.git \
&& cd ${APP} \
&& git checkout ${CHECKOUT} . \
&& mkdir -p build \
&& cd build \
&& cmake .. \
&& make \
&& make install
