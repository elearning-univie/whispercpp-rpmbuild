#!/bin/bash

set -e
set -u

# setup install dependencies
${CI_PROJECT_DIR:-/build}/scripts/install-dependencies.sh ${1}

# setup build tree
rpmdev-setuptree
rm -rf /root/.rpmmacros
cp -r /root/rpmbuild ${CI_PROJECT_DIR:-/build}/rpmbuild

# copy spec file
cp ${CI_PROJECT_DIR:-/build}/spec/${BUILD_MODE:-static}/${1}.spec ${CI_PROJECT_DIR:-/build}/rpmbuild/SPECS/${1}.spec
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
    --define "relver ${RELEASE_VERSION:-1}" \
    --define "version ${CHECKOUT:-$VERSION}" \
    --define "src_path ${SRC_PATCH}" \
    --define "arch ${ARCH}" \
    --nodebuginfo -bb SPECS/${1}.spec

# copy artifacts
mkdir -p ${CI_PROJECT_DIR:-/build}/build
# rm -rf ${CI_PROJECT_DIR:-/build}/build/${1}-*.${DISTRIBUTION}.*.rpm
find ${CI_PROJECT_DIR:-/build}/rpmbuild -name "*.rpm" -exec mv {} -t ${CI_PROJECT_DIR:-/build}/build \;
