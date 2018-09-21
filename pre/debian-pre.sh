#!/usr/bin/env bash

apt update -y
apt install -y netselect-apt && \
netselect-apt && \
mv sources.list /etc/apt/sources.list && \
apt update -y && \
apt remove -y netselect-apt && \
apt autoremove -y && \
rm -rf /var/lib/apt/lists/*
