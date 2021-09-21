#!/usr/bin/env bash

set -e

# default - vars
STAGE="stable"
[ -z "${BUILD}" ] && BUILD=""
REGISTRY="${REGISTRY:-}"

# build gvmlibs
source ./src/gvm-libs/commit/stable
gvmlibs_version=${gvmlibs_version}
build_gvmlibs="${BUILD}"
echo "
################################################################################
################### Build gvmlibs ##############################################
################################################################################
Image: ${REGISTRY}dgiorgio/gvmlibs:${gvmlibs_version}${build_gvmlibs}"
docker build -f ./Dockerfile-gvmlibs --build-arg STAGE=${STAGE} \
  -t "${REGISTRY}dgiorgio/gvmlibs:${gvmlibs_version}${build_gvmlibs}" \
  -t "${REGISTRY}dgiorgio/gvmlibs:latest" .

# build gsa
source ./src/gsa/commit/stable
gsa_version=${gsa_version}
build_gsa="-1"
echo "
################################################################################
################### Build gsa ##################################################
################################################################################
Image: ${REGISTRY}dgiorgio/gsa:${gsa_version}${build_gsa}"
docker build -f ./Dockerfile-gsa --build-arg STAGE=${STAGE} \
  -t "${REGISTRY}dgiorgio/gsa:${gsa_version}${build_gsa}" \
  -t "${REGISTRY}dgiorgio/gsa:latest" .

# build openvas
source ./src/openvas-scanner/commit/stable
openvas_scanner_version=${openvas_scanner_version}
build_openvas_scanner="-1"
echo "
################################################################################
################### Build openvas-scanner ##############################################
################################################################################
Image: ${REGISTRY}dgiorgio/openvas-scanner:${openvas_scanner_version}${build_openvas_scanner}
Image: ${REGISTRY}dgiorgio/openvas:${openvas_scanner_version}${build_openvas_scanner}"
# dgiorgio/openvas compatibility with older builds, will be removed on 02/23/2022
docker build -f ./Dockerfile-openvas --build-arg STAGE=${STAGE} \
  -t "${REGISTRY}dgiorgio/openvas:${openvas_scanner_version}${build_openvas_scanner}" \
  -t "${REGISTRY}dgiorgio/openvas:latest" \
  -t "${REGISTRY}dgiorgio/openvas-scanner:${openvas_scanner_version}${build_openvas_scanner}" \
  -t "${REGISTRY}dgiorgio/openvas-scanner:latest" .

# build gvmd
source ./src/gvmd/commit/stable
gvmd_version=${gvmd_version}
build_gvmd="-2"
echo "
################################################################################
################### Build gvmd #################################################
################################################################################
Image: ${REGISTRY}dgiorgio/gvmd:${gvmd_version}${build_gvmd}"
docker build -f ./Dockerfile-gvmd --build-arg STAGE=${STAGE} \
  -t "${REGISTRY}dgiorgio/gvmd:${gvmd_version}${build_gvmd}" \
  -t "${REGISTRY}dgiorgio/gvmd:latest" .

postgres_gvm_version=11.13
build_postgres_gvm="-${gvmd_version}-1"
echo "
################################################################################
################### Build postgres-gvm #########################################
################################################################################
Image: ${REGISTRY}dgiorgio/postgres-gvm:${postgres_gvm_version}${build_postgres_gvm}"
docker build -f ./Dockerfile-postgres-gvm --build-arg STAGE=${STAGE} \
  -t "${REGISTRY}dgiorgio/postgres-gvm:${postgres_gvm_version}${build_postgres_gvm}" \
  -t "${REGISTRY}dgiorgio/postgres-gvm:latest" .

echo "All images successfully built."

# push
if [ "${1}" == "push" ]; then
  docker push "${REGISTRY}dgiorgio/gvmlibs:${gvmlibs_version}${build_gvmlibs}"
  docker push "${REGISTRY}dgiorgio/gvmlibs:latest"

  docker push "${REGISTRY}dgiorgio/gsa:${gsa_version}${build_gsa}"
  docker push "${REGISTRY}dgiorgio/gsa:latest"

  docker push "${REGISTRY}dgiorgio/openvas-scanner:${openvas_scanner_version}${build_openvas_scanner}"
  docker push "${REGISTRY}dgiorgio/openvas-scanner:latest"
  docker push "${REGISTRY}dgiorgio/openvas:${openvas_scanner_version}${build_openvas_scanner}"
  docker push "${REGISTRY}dgiorgio/openvas:latest"
  # dgiorgio/openvas compatibility with older builds, will be removed on 02/23/2022

  docker push "${REGISTRY}dgiorgio/gvmd:${gvmd_version}${build_gvmd}"
  docker push "${REGISTRY}dgiorgio/gvmd:latest"

  docker push "${REGISTRY}dgiorgio/postgres-gvm:${postgres_gvm_version}${build_postgres_gvm}"
  docker push "${REGISTRY}dgiorgio/postgres-gvm:latest"

  echo "All images sent successfully."
fi
