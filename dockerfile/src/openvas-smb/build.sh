#!/usr/bin/env bash

STAGE="${1}"
[[ "${STAGE}" == "" ]] && STAGE="stable"

source "./${STAGE}"

_build(){
  mkdir -p build \
  && cd build \
  && cmake .. \
  && make -j$(($(nproc) + 1)) \
  && make install
}

_download_git(){
  git clone https://github.com/greenbone/openvas-smb.git \
  && cd openvas-smb \
  && git reset --hard ${COMMIT}
}

_dowload_release(){
  wget -c ${RELEASE_URL} \
  && tar -xzvf *.tar.gz \
  && cd openvas-smb*
}

if [ ! -z "${COMMIT}" ]; then
  _download_git
else
  _dowload_release
fi

_build
