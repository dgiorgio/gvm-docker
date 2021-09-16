#!/usr/bin/env bash

set -e

# default - vars
STAGE="stable"
[ -z "${BUILD}" ] && BUILD=""

# build gvmlibs
source ./src/gvm-libs/commit/stable
gvmlibs_version=${gvmlibs_version}
build_gvmlibs="${BUILD}"
echo "
################################################################################
################### Build gvmlibs ##############################################
################################################################################
Image: dgiorgio/gvmlibs:${gvmlibs_version}${build_gvmlibs}"
docker build -f ./Dockerfile-gvmlibs --build-arg STAGE=${STAGE} \
  -t "dgiorgio/gvmlibs:${gvmlibs_version}${build_gvmlibs}" \
  -t "dgiorgio/gvmlibs:latest" .

# build gsa
source ./src/gsa/commit/stable
gsa_version=${gsa_version}
build_gsa="-1"
echo "
################################################################################
################### Build gsa ##################################################
################################################################################
Image: dgiorgio/gsa:${gsa_version}${build_gsa}"
docker build -f ./Dockerfile-gsa --build-arg STAGE=${STAGE} \
  -t "dgiorgio/gsa:${gsa_version}${build_gsa}" \
  -t "dgiorgio/gsa:latest" .

# build openvas
source ./src/openvas-scanner/commit/stable
openvas_scanner_version=${openvas_scanner_version}
build_openvas_scanner="${BUILD}"
echo "
################################################################################
################### Build openvas-scanner ##############################################
################################################################################
Image: dgiorgio/openvas-scanner:${openvas_scanner_version}${build_openvas_scanner}
Image: dgiorgio/openvas:${openvas_scanner_version}${build_openvas_scanner}"
# dgiorgio/openvas compatibility with older builds, will be removed on 02/23/2022
docker build -f ./Dockerfile-openvas --build-arg STAGE=${STAGE} \
  -t "dgiorgio/openvas:${openvas_scanner_version}${build_openvas_scanner}" \
  -t "dgiorgio/openvas:latest" \
  -t "dgiorgio/openvas-scanner:${openvas_scanner_version}${build_openvas_scanner}" \
  -t "dgiorgio/openvas-scanner:latest" .

# build gvmd
source ./src/gvmd/commit/stable
gvmd_version=${gvmd_version}
build_gvmd="${BUILD}"
echo "
################################################################################
################### Build gvmd #################################################
################################################################################
Image: dgiorgio/gvmd:${gvmd_version}${build_gvmd}"
docker build -f ./Dockerfile-gvmd --build-arg STAGE=${STAGE} \
  -t "dgiorgio/gvmd:${gvmd_version}${build_gvmd}" \
  -t "dgiorgio/gvmd:latest" .

postgres_gvm_version=11.13
build_postgres_gvm="-${gvmd_version}"
echo "
################################################################################
################### Build postgres-gvm #########################################
################################################################################
Image: dgiorgio/postgres-gvm:${postgres_gvm_version}${build_postgres_gvm}"
docker build -f ./Dockerfile-postgres-gvm --build-arg STAGE=${STAGE} \
  -t "dgiorgio/postgres-gvm:${postgres_gvm_version}${build_postgres_gvm}" \
  -t "dgiorgio/postgres-gvm:latest" .

echo "All images successfully built."

# push
if [ "${1}" == "push" ]; then
  docker push "dgiorgio/gvmlibs:${gvmlibs_version}${build_gvmlibs}"
  docker push "dgiorgio/gvmlibs:latest"

  docker push "dgiorgio/gsa:${gsa_version}${build_gsa}"
  docker push "dgiorgio/gsa:latest"

  docker push "dgiorgio/openvas-scanner:${openvas_scanner_version}${build_openvas_scanner}"
  docker push "dgiorgio/openvas-scanner:latest"
  docker push "dgiorgio/openvas:${openvas_scanner_version}${build_openvas_scanner}"
  docker push "dgiorgio/openvas:latest"
  # dgiorgio/openvas compatibility with older builds, will be removed on 02/23/2022

  docker push "dgiorgio/gvmd:${gvmd_version}${build_gvmd}"
  docker push "dgiorgio/gvmd:latest"

  docker push "dgiorgio/postgres-gvm:${postgres_gvm_version}${build_postgres_gvm}"
  docker push "dgiorgio/postgres-gvm:latest"

  echo "All images sent successfully."
fi
