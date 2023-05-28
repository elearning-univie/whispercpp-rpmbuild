#!/bin/bash

set -e
set -u

# setup build tree
rpmdev-setuptree
rm -rf /root/.rpmmacros
cp -r /root/rpmbuild ${CI_PROJECT_DIR}/rpmbuild

# copy spec file
cp ${CI_PROJECT_DIR}/spec/${BUILD_MODE}/${1}.spec ${CI_PROJECT_DIR}/rpmbuild/SPECS/${1}.spec
cd ${CI_PROJECT_DIR}/rpmbuild

# build rpm
rpmbuild \
    --define "_topdir ${CI_PROJECT_DIR}/rpmbuild" \
    --define "relver ${RELEASE_VERSION}" \
    --nodebuginfo -bb SPECS/${1}.spec
