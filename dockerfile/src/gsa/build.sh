#!/usr/bin/env bash

STAGE="${1}"
[[ "${STAGE}" == "" ]] && STAGE="stable"

source "./${STAGE}"

_build(){
  yarn \
  && npx browserslist@latest --update-db \
  && yarn build \
  && mkdir -p /usr/local/share/gvm/gsad \
  && mv build /usr/local/share/gvm/gsad/web
}

_download_git(){
  git clone https://github.com/greenbone/gsa.git \
  && cd gsa \
  && git reset --hard ${COMMIT}
}

_dowload_release(){
  wget -c ${RELEASE_URL} \
  && tar -xzvf *.tar.gz \
  && cd gsa*
}

if [ ! -z "${COMMIT}" ]; then
  _download_git
else
  _dowload_release
fi

_build
