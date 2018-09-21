# Install gvm-libs
APP="gvm-libs"
VERSION="9.0.1"
wget https://github.com/greenbone/gvm-libs/archive/v${VERSION}.tar.gz \
&& tar -xzvf v${VERSION}.tar.gz \
&& mkdir -p ${APP}-${VERSION}/build \
&& cd ${APP}-${VERSION}/build \
&& cmake .. \
&& make \
&& make install
