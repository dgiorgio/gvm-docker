#!/usr/bin/env bash

# Install ospd-openvas
APP="ospd-openvas"
CHECKOUT="3f6d407b1b81c1b8b2d9482847270d74784a3928"

git clone https://github.com/greenbone/${APP}.git \
&& cd ${APP} \
&& git checkout ${CHECKOUT} \
&& python3 setup.py install
