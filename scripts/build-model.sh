#!/bin/bash

set -e
set -u

# setup build tree
rpmdev-setuptree
rm -rf /root/.rpmmacros
cp -r /root/rpmbuild ${CI_PROJECT_DIR:-/build}/rpmbuild

# copy spec file
cp ${CI_PROJECT_DIR:-/build}/spec/model/whisper-ggml-template.spec ${CI_PROJECT_DIR:-/build}/rpmbuild/SPECS/whisper-ggml-${1}.spec
cd ${CI_PROJECT_DIR:-/build}/rpmbuild

# check for version
if [ "${VERSION:-master}" == "master" ]; then
    CHECKOUT=$(curl "https://api.github.com/repos/ggerganov/whisper.cpp/tags" | jq -r '.[0].name' | sed "s/^v//")
    SRC_PATCH="heads/master.tar.gz"
else
    SRC_PATCH="tags/v%{version}.tar.gz"
fi


ARCH=$(uname -m)
echo "Build ${1}-${CHECKOUT:-$VERSION}-${RELEASE_VERSION:-1}.${ARCH}.rpm"

# build rpm
rpmbuild \
    --define "_topdir ${CI_PROJECT_DIR:-/build}/rpmbuild" \
    --define "ggmodel ${1}" \
    --define "relver ${RELEASE_VERSION:-1}" \
    --define "version ${CHECKOUT:-$VERSION}" \
    --define "src_path ${SRC_PATCH}" \
    --define "arch ${ARCH}" \
    --nodebuginfo -bb SPECS/whisper-ggml-${1}.spec

# copy artifacts
mkdir -p ${CI_PROJECT_DIR:-/build}/build
find ${CI_PROJECT_DIR:-/build}/rpmbuild -name "*.rpm" -exec mv {} -t ${CI_PROJECT_DIR:-/build}/build \;
