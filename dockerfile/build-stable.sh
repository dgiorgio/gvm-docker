#!/usr/bin/env bash

set -e

# default - vars
STAGE="stable"
[ -z "${BUILD}" ] && BUILD=""

# build gvmlibs
app=gvmlibs
version=11.0
build_gvmlibs=""
docker build -f ./Dockerfile-${app} --build-arg STAGE=${STAGE} \
  -t "dgiorgio/${app}:${version}${build_gvmlibs:-${BUILD}}" \
  -t "dgiorgio/${app}:latest" .

# build gvmd
app=gvmd
version=9.0
gvm_version=9.0
build_gvmd=""
docker build -f ./Dockerfile-${app} --build-arg STAGE=${STAGE} \
  -t "dgiorgio/${app}:${version}${build_gvmd:-${BUILD}}" \
  -t "dgiorgio/${app}:latest" .

# build openvas
app=openvas
version=7.0
build_openvas=""
docker build -f ./Dockerfile-${app} --build-arg STAGE=${STAGE} \
  -t "dgiorgio/${app}:${version}${build_openvas:-${BUILD}}" \
  -t "dgiorgio/${app}:latest" .

# build gsa
app=gsa
version=9.0
build_gsa=""
docker build -f ./Dockerfile-${app} --build-arg STAGE=${STAGE} \
  -t "dgiorgio/${app}:${version}${build_gsa:-${BUILD}}" \
  -t "dgiorgio/${app}:latest" .

# build postgres
app=postgres-gvm
version=9.6
build_postgres=""
docker build -f ./Dockerfile-${app} --build-arg STAGE=${STAGE} \
  -t "dgiorgio/${app}:${version}${build_postgres:-${BUILD}}" \
  -t "dgiorgio/${app}:latest" .

# # push
# if [ "${1}" == "push" ]; then
#   for app in gvmlibs openvas gsa gvmd ; do
#     for tag in "${DATE}${BUILD}" "latest"; do
#       docker push "dgiorgio/${app}:${tag}"
#     done
#   done
#
#   # push gvmd
#   for tag in "${DATE}${DATABASE_TAG}${BUILD}" "latest${DATABASE_TAG}"; do
#     docker push "dgiorgio/gvmd:${tag}"
#   done
# fi
