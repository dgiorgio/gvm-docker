#!/usr/bin/env bash

set -e

# default - vars
STAGE="stable"
[ -z "${BUILD}" ] && BUILD="-20201004"

# build gvmlibs
gvmlibs_version=20.08
build_gvmlibs="${BUILD}"
echo "
################################################################################
################### Build gvmlibs ##############################################
################################################################################
Image: dgiorgio/gvmlibs:${gvmlibs_version}${build_gvmlibs}"
docker build -f ./Dockerfile-gvmlibs --build-arg STAGE=${STAGE} \
  -t "dgiorgio/gvmlibs:${gvmlibs_version}${build_gvmlibs}" \
  -t "dgiorgio/gvmlibs:latest" .

# build gvmd
gvmd_version=20.08
build_gvmd="${BUILD}"
echo "
################################################################################
################### Build gvmd #################################################
################################################################################
Image: dgiorgio/gvmd:${gvmd_version}${build_gvmd}"
docker build -f ./Dockerfile-gvmd --build-arg STAGE=${STAGE} \
  -t "dgiorgio/gvmd:${gvmd_version}${build_gvmd}" \
  -t "dgiorgio/gvmd:latest" .

# build openvas
openvas_version=20.08
build_openvas="${BUILD}"
echo "
################################################################################
################### Build openvas ##############################################
################################################################################
Image: dgiorgio/openvas:${openvas_version}${build_openvas}"
docker build -f ./Dockerfile-openvas --build-arg STAGE=${STAGE} \
  -t "dgiorgio/openvas:${openvas_version}${build_openvas}" \
  -t "dgiorgio/openvas:latest" .

# build gsa
gsa_version=20.08
build_gsa="${BUILD}"
echo "
################################################################################
################### Build gsa ##################################################
################################################################################
Image: dgiorgio/gsa:${gsa_version}${build_gsa}"
docker build -f ./Dockerfile-gsa --build-arg STAGE=${STAGE} \
  -t "dgiorgio/gsa:${gsa_version}${build_gsa}" \
  -t "dgiorgio/gsa:latest" .

# build postgres
postgres_version=9.6
build_postgres="${BUILD}"
echo "
################################################################################
################### Build postgres #############################################
################################################################################
Image: dgiorgio/postgres:${postgres_version}${build_postgres}"
docker build -f ./Dockerfile-postgres --build-arg STAGE=${STAGE} \
  -t "dgiorgio/postgres:${postgres_version}${build_postgres}" \
  -t "dgiorgio/postgres:latest" .

postgres_gvm_version=9.6
build_postgres_gvm="${BUILD}"
echo "
################################################################################
################### Build postgres-gvm #########################################
################################################################################
Image: dgiorgio/postgres-gvm:${postgres_gvm_version}${build_postgres_gvm}"
docker build -f ./Dockerfile-postgres-gvm --build-arg STAGE=${STAGE} \
  -t "dgiorgio/postgres-gvm:${postgres_gvm_version}${build_postgres_gvm}" \
  -t "dgiorgio/postgres-gvm:latest" .

# push
if [ "${1}" == "push" ]; then
  docker push "dgiorgio/gvmlibs:${gvmlibs_version}${build_gvmlibs}"
  docker push "dgiorgio/gvmlibs:latest"

  docker push "dgiorgio/gvmd:${gvmd_version}${build_gvmd}"
  docker push "dgiorgio/gvmd:latest"

  docker push "dgiorgio/openvas:${openvas_version}${build_openvas}"
  docker push "dgiorgio/openvas:latest"

  docker push "dgiorgio/gsa:${gsa_version}${build_gsa}"
  docker push "dgiorgio/gsa:latest"

  docker push "dgiorgio/postgres:${postgres_version}${build_postgres}"
  docker push "dgiorgio/postgres:latest"

  docker push "dgiorgio/postgres-gvm:${postgres_gvm_version}${build_postgres_gvm}"
  docker push "dgiorgio/postgres-gvm:latest"
fi
