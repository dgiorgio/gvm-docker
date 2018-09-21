#!/usr/bin/env bash

ldconfig

gvm-manage-certs -af

gvmd

gsad -f

tail -f /var/log/lastlog
