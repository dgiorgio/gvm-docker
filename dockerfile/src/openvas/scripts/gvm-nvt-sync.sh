#!/usr/bin/env bash

if [ "$(ls -A /usr/local/var/lib/openvas/plugins)" ]; then
  greenbone-nvt-sync --rsync
else
  greenbone-nvt-sync --wget
fi
