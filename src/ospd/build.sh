# Install ospd
APP="ospd"
CHECKOUT="36027d4c3a74c8bdec2cc49410b3fd0fa4b746c3"

git clone https://github.com/greenbone/${APP}.git \
&& cd ${APP} \
&& git checkout ${CHECKOUT} \
&& python3 setup.py install
