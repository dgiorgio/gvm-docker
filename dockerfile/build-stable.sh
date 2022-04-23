#!/usr/bin/env bash

set -e

# default - vars
STAGE="stable"
[ -z "${BUILD}" ] && BUILD=""
REGISTRY="${REGISTRY:-}"

# load versions
source ./VERSIONS

# build gvmlibs
gvmlibs_version=${gvmlibs_version}
build_gvmlibs="${BUILD}"
echo "
################################################################################
################### Build gvmlibs ##############################################
################################################################################
Image: ${REGISTRY}dgiorgio/gvmlibs:${gvmlibs_version}${build_gvmlibs}"
docker build -f ./Dockerfile-gvmlibs --build-arg STAGE=${STAGE} \
  --build-arg gvmlibs_version=${gvmlibs_version} --build-arg gvmlibs_debian_version=${gvmlibs_debian_version} \
  -t "${REGISTRY}dgiorgio/gvmlibs:${gvmlibs_version}${build_gvmlibs}" \
  -t "${REGISTRY}dgiorgio/gvmlibs:latest" .

# build gsa
gsa_version=${gsa_version}
build_gsa="${BUILD}"
echo "
################################################################################
################### Build gsa ##################################################
################################################################################
Image: ${REGISTRY}dgiorgio/gsa:${gsa_version}${build_gsa}"
docker build -f ./Dockerfile-gsa --build-arg STAGE=${STAGE} \
  --build-arg gvmlibs_version=${gvmlibs_version} --build-arg gsa_version=${gsa_version} --build-arg gsad_version=${gsad_version} \
  -t "${REGISTRY}dgiorgio/gsa:${gsa_version}${build_gsa}" \
  -t "${REGISTRY}dgiorgio/gsa:latest" .

# build openvas
openvas_scanner_version=${openvas_scanner_version}
build_openvas_scanner="${BUILD}"
echo "
################################################################################
################### Build openvas-scanner ##############################################
################################################################################
Image: ${REGISTRY}dgiorgio/openvas-scanner:${openvas_scanner_version}${build_openvas_scanner}"
docker build -f ./Dockerfile-openvas --build-arg STAGE=${STAGE} \
  --build-arg gvmlibs_version=${gvmlibs_version} --build-arg openvas_smb_version=${openvas_smb_version} \
  --build-arg ospd_openvas_version=${ospd_openvas_version} --build-arg openvas_scanner_version=${openvas_scanner_version} \
  -t "${REGISTRY}dgiorgio/openvas-scanner:${openvas_scanner_version}${build_openvas_scanner}" \
  -t "${REGISTRY}dgiorgio/openvas-scanner:latest" .

# build gvmd
gvmd_version=${gvmd_version}
build_gvmd="${BUILD}"
echo "
################################################################################
################### Build gvmd #################################################
################################################################################
Image: ${REGISTRY}dgiorgio/gvmd:${gvmd_version}${build_gvmd}"
docker build -f ./Dockerfile-gvmd --build-arg STAGE=${STAGE} \
  --build-arg gvmlibs_version=${gvmlibs_version} --build-arg gvmd_version=${gvmd_version} --build-arg openvas_scanner_version=${openvas_scanner_version} \
  -t "${REGISTRY}dgiorgio/gvmd:${gvmd_version}${build_gvmd}" \
  -t "${REGISTRY}dgiorgio/gvmd:latest" .

build_postgres_gvm="-${gvmd_version}"
echo "
################################################################################
################### Build postgres-gvm #########################################
################################################################################
Image: ${REGISTRY}dgiorgio/postgres-gvm:${postgres_gvm_version}${build_postgres_gvm}"
docker build -f ./Dockerfile-postgres-gvm --build-arg STAGE=${STAGE} \
  --build-arg postgres_gvm_version=${postgres_gvm_version} --build-arg gvmd_version=${gvmd_version} \
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

  docker push "${REGISTRY}dgiorgio/gvmd:${gvmd_version}${build_gvmd}"
  docker push "${REGISTRY}dgiorgio/gvmd:latest"

  docker push "${REGISTRY}dgiorgio/postgres-gvm:${postgres_gvm_version}${build_postgres_gvm}"
  docker push "${REGISTRY}dgiorgio/postgres-gvm:latest"

  echo "All images sent successfully."
fi
