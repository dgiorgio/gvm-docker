#!/usr/bin/env bash

versions_file="../../dockerfile/VERSIONS"

docker-compose -p gvm --env-file "${versions_file}" -f docker-compose.yml up -d
