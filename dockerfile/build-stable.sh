#!/usr/bin/env bash

set -e

# default - vars
DATE="$(date +%Y%m%d)"
STAGE="stable"
[ -z "${BUILD}" ] && BUILD=""

# build
for app in gvmlibs openvas gsa ; do
  docker build -f ./Dockerfile-${app} --build-arg STAGE=${STAGE} \
    -t "dgiorgio/${app}:${DATE}${BUILD}" \
    -t "dgiorgio/${app}:latest" .
done

# build gvmd
[ -z "${DATABASE}" ] && DATABASE="sqlite"
[ "${DATABASE}" == "sqlite" ] && DATABASE_TAG="" || DATABASE_TAG="-${DATABASE}"
docker build -f ./Dockerfile-gvmd --build-arg STAGE=${STAGE} --build-arg DATABASE=${DATABASE} \
  -t "dgiorgio/gvmd:${DATE}${DATABASE_TAG}${BUILD}" \
  -t "dgiorgio/gvmd:latest${DATABASE_TAG}" .

# push
if [ "${1}" == "push" ]; then
  for app in gvmlibs openvas gsa ; do
    for tag in "${DATE}${BUILD}" "latest"; do
      docker push "dgiorgio/${app}:${tag}"
    done
  done

  # push gvmd
  for tag in "${DATE}${DATABASE_TAG}${BUILD}" "latest${DATABASE_TAG}"; do
    docker push "dgiorgio/gvmd:${tag}"
  done
fi
