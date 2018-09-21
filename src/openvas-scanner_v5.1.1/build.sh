# Install gvm-libs
APP="openvas-scanner"
VERSION="5.1.1"
wget https://github.com/greenbone/${APP}/archive/v${VERSION}.tar.gz \
&& tar -xzvf v${VERSION}.tar.gz \
&& mkdir -p ${APP}-${VERSION}/build \
&& cd ${APP}-${VERSION}/build \
&& cmake .. \
&& make \
&& make install
