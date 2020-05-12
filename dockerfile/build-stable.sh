#!/usr/bin/env bash

set -e

# default - vars
STAGE="stable"
[ -z "${BUILD}" ] && BUILD=""

# build gvmlibs
echo "
################################################################################
################### Build gvmlibs ##############################################
################################################################################"
gvmlibs_version=11.0
build_gvmlibs="-p2"
docker build -f ./Dockerfile-gvmlibs --build-arg STAGE=${STAGE} \
  -t "dgiorgio/gvmlibs:${gvmlibs_version}${build_gvmlibs:-${BUILD}}" \
  -t "dgiorgio/gvmlibs:latest" .

# build gvmd
echo "
################################################################################
################### Build gvmd #################################################
################################################################################"
gvmd_version=9.0
build_gvmd="-p2"
docker build -f ./Dockerfile-gvmd --build-arg STAGE=${STAGE} \
  -t "dgiorgio/gvmd:${gvmd_version}${build_gvmd:-${BUILD}}" \
  -t "dgiorgio/gvmd:latest" .

# build openvas
echo "
################################################################################
################### Build openvas ##############################################
################################################################################"
openvas_version=7.0
build_openvas="-p2"
docker build -f ./Dockerfile-openvas --build-arg STAGE=${STAGE} \
  -t "dgiorgio/openvas:${openvas_version}${build_openvas:-${BUILD}}" \
  -t "dgiorgio/openvas:latest" .

# build gsa
echo "
################################################################################
################### Build gsa ##################################################
################################################################################"
gsa_version=9.0
build_gsa="-p2"
docker build -f ./Dockerfile-gsa --build-arg STAGE=${STAGE} \
  -t "dgiorgio/gsa:${gsa_version}${build_gsa:-${BUILD}}" \
  -t "dgiorgio/gsa:latest" .

# build postgres
echo "
################################################################################
################### Build postgres #############################################
################################################################################"
postgres_version=9.6
build_postgres=""
docker build -f ./Dockerfile-postgres --build-arg STAGE=${STAGE} \
  -t "dgiorgio/postgres:${postgres_version}${build_postgres:-${BUILD}}" \
  -t "dgiorgio/postgres:latest" .

postgres_gvm_version=9.6
build_postgres_gvm="-p3"
docker build -f ./Dockerfile-postgres-gvm --build-arg STAGE=${STAGE} \
  -t "dgiorgio/postgres-gvm:${postgres_gvm_version}${build_postgres_gvm:-${BUILD}}" \
  -t "dgiorgio/postgres-gvm:latest" .

# push
if [ "${1}" == "push" ]; then
  docker push "dgiorgio/gvmlibs:${gvmlibs_version}${build_gvmlibs:-${BUILD}}"
  docker push "dgiorgio/gvmlibs:latest"

  docker push "dgiorgio/gvmd:${gvmd_version}${build_gvmd:-${BUILD}}"
  docker push "dgiorgio/gvmd:latest"

  docker push "dgiorgio/openvas:${openvas_version}${build_openvas:-${BUILD}}"
  docker push "dgiorgio/openvas:latest"

  docker push "dgiorgio/gsa:${gsa_version}${build_gsa:-${BUILD}}"
  docker push "dgiorgio/gsa:latest"

  docker push "dgiorgio/postgres:${postgres_version}${build_postgres:-${BUILD}}"
  docker push "dgiorgio/postgres:latest"

  docker push "dgiorgio/postgres-gvm:${postgres_gvm_version}${build_postgres_gvm:-${BUILD}}"
  docker push "dgiorgio/postgres-gvm:latest"
fi
