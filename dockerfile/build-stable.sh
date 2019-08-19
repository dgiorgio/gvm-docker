#!/usr/bin/env bash

set -e

# default - vars
DATE="$(date +%Y%m%d)"
STAGE="stable"
[ -z "${BUILD}" ] && BUILD=""

# build
for app in gvmlibs openvas gsa ; do
  docker build -f ./Dockerfile-${app} --build-arg STAGE=${STAGE} \
    -t "dgiorgio/${app}:${DATE}-${STAGE}${BUILD}" \
    -t "dgiorgio/${app}:latest-${STAGE}" \
    -t "dgiorgio/${app}:latest" .
done

[ -z "${DATABASE}" ] && DATABASE="sqlite"
[ "${DATABASE}" == "postgres" ] && DATABASE_TAG="-postgres" || DATABASE_TAG=""
docker build -f ./Dockerfile-gvmd --build-arg STAGE=${STAGE} --build-arg DATABASE=${DATABASE} \
  -t "dgiorgio/gvmd:${DATE}${DATABASE_TAG}-${STAGE}${BUILD}" \
  -t "dgiorgio/gvmd:latest${DATABASE_TAG}-${STAGE}" \
  -t "dgiorgio/gvmd:latest${DATABASE_TAG}" .

# push
if [ "${1}" == "push" ]; then
  for app in gvmlibs gvmd openvas gsa ; do
    for tag in "${DATE}-${STAGE}${BUILD}" "latest-${STAGE}" "latest"; do
      docker push "dgiorgio/${app}:${tag}"
    done
  done
fi
