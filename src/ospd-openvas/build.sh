# Install ospd-openvas
APP="ospd-openvas"
git clone https://github.com/greenbone/${APP}.git \
&& cd ${APP} \
&& python3 setup.py install
