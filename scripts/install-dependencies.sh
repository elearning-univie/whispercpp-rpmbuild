#!/bin/bash

set -e

if [ -z "${1}" ]; then
    echo "No input. Skip"
    echo "Allowed: whispercpp, whispercpp-cublas"
else

    if [[ "${1}" == "whispercpp" ]]; then
        dnf -y install openblas-devel atlas-devel
    elif [[ "${1}" == "whispercpp-cublas" ]]; then
        dnf -y config-manager --add-repo https://developer.download.nvidia.com/compute/cuda/repos/rhel${DISTRIBUTION//[!0-9]/}/x86_64/cuda-rhel${DISTRIBUTION//[!0-9]/}.repo
        dnf -y module install nvidia-driver:latest-dkms
        dnf -y install cuda openblas-devel atlas-devel
    else
        echo "No dependencies for ${1}"
    fi
fi
