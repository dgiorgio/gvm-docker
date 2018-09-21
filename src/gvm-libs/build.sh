# Install gvm-libs
APP="gvm-libs"
git clone https://github.com/greenbone/${APP}.git \
&& mkdir -p ${APP}/build \
&& cd ${APP}/build \
&& cmake .. \
&& make \
&& make install
