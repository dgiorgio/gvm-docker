# Install gvm
APP="gvmd"
CHECKOUT="8bc90781c4c27c9e3ad5a14ea99aa38b6eb9a3f3"

git clone https://github.com/greenbone/${APP}.git \
&& cd ${APP} \
&& git checkout ${CHECKOUT} . \
&& mkdir -p build \
&& cd build \
&& cmake .. \
&& make \
&& make install
