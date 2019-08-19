#!/usr/bin/env bash

# default - vars
DATE="$(date +%Y%m%d)"
STAGE="dev"
[ -z "${BUILD}" ] && BUILD=""
DATABASE="sqlite" # gvmd build

# build
for app in gvmlibs openvas gsa ; do
  docker build -f ./Dockerfile-${app} --build-arg STAGE=${STAGE} \
    -t "dgiorgio/${app}:${DATE}-${STAGE}${BUILD}" \
    -t "dgiorgio/${app}:latest-${STAGE}" \
    -t "dgiorgio/${app}:latest" .
done

docker build -f ./Dockerfile-gvmd --build-arg STAGE=${STAGE} --build-arg DATABASE=${DATABASE} \
  -t "dgiorgio/gvmd:${DATE}-${STAGE}${BUILD}" \
  -t "dgiorgio/gvmd:latest-${STAGE}" \
  -t "dgiorgio/gvmd:latest" .

# push
if [ "${1}" == "push" ]; then
  for app in gvmlibs gvmd openvas gsa ; do
    for tag in "${DATE}-${STAGE}${BUILD}" "latest-${STAGE}" "latest"; do
      docker push "dgiorgio/${app}:${tag}"
    done
  done
fi
