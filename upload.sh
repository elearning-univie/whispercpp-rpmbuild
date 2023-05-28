#!/bin/bash

set -u
set -e
#set -x

# working directory
RPM_ARTIFACTS_DIR=${CI_PROJECT_DIR}/build

mkdir -p ${RPM_ARTIFACTS_DIR}
find ${CI_PROJECT_DIR}/rpmbuild -name "*.rpm" -exec mv {} -t ${RPM_ARTIFACTS_DIR} \;

# find upload rpm to yum repo
RPM_ARTIFACTS=$(find ${RPM_ARTIFACTS_DIR} -name "*.rpm")

for file in ${RPM_ARTIFACTS}; do
  filename=$(echo ${file} | rev | cut -d '/' -f 1 | rev)
  dist_version=$(echo ${filename} | cut -d '.' -f 4 | egrep -o '[0-9.]+')
  arch=$(echo ${filename} | cut -d '.' -f 5)
  echo "filename:        ${filename}"
  echo "dist_version:    ${dist_version}"
  echo "arch:            ${arch}"
  if [ "${arch}" != "src" ]; then
    curl --user "${YUM_REPO_USER}:${YUM_REPO_PASS}" --upload-file ${file} https://${YUM_REPO_URL}/${dist_version}/${arch}/${filename}
  fi
done
