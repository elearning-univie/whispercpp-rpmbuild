#!/bin/bash

set -e
set -u

# setup build tree
rpmdev-setuptree
rm -rf /root/.rpmmacros
cp -r /root/rpmbuild ${CI_PROJECT_DIR}/rpmbuild

# copy spec file
cp ${CI_PROJECT_DIR}/spec/model/whisper-ggml-template.spec ${CI_PROJECT_DIR}/rpmbuild/SPECS/whisper-ggml-${1}.spec
cd ${CI_PROJECT_DIR}/rpmbuild

# build rpm
rpmbuild \
    --define "_topdir ${CI_PROJECT_DIR}/rpmbuild" \
    --define "ggmodel ${MODEL_NAME}" \
    --define "relver ${RELEASE_VERSION}" \
    --nodebuginfo -bb SPECS/whisper-ggml-${1}.spec
