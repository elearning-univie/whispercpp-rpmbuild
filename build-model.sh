#!/bin/bash

# CMD is the shell-script name without directory (basename)
CMD="${0##*/}"


list_help() {
    echo ""
    echo "Usage: ./build-model.sh -d DIST -v VERSION -r REL_VER MODELS"
    echo ""
    echo "Mandatory: MODELS           tiny, base, small, medium, large"
    echo "Mandatory: [-d] DIST        el8, el9"
    echo "Optional:  [-v] VERSION     Branch/Tag     (Default: master)"
    echo "Optional:  [-r] REL_VER     Number         (Default: 1)"
    echo ""
}

get_opts() {
    SOPTS="d:r:v:"
    TMP=$(getopt -o "$SOPTS" -n "$CMD" -- "$@") || exit 1
    eval set -- "$TMP"
    unset TMP

    while true; do
        case "$1" in
            -r)
                # printf "[%s] RELEASE_VERSION: %s\n" "$1" "$2"
                RELEASE_VERSION=${2:-1}
                shift
                ;;
            -d)
                # printf "[-d] DISTRIBUTION: %s\n" "$2"
                DISTRIBUTION=${2}
                shift
                ;;
            -v)
                # printf "[-v] VERSION: %s\n" "$2"
                VERSION=${2:-master}
                shift
                ;;
            --)
                shift
                break
                ;;

        esac
        shift
    done

    nargs=$#
    # printf "remaining %d args :\n" "$nargs"
    for ((i=0; i<nargs; ++i)); do
        # printf "Build rpm %d: %s\n" $((i + 1)) "$1"
        MODELS="${MODELS} ${1}"
        shift
    done
}

prepare_builder() {
    podman build -t whispercpp-builder:${DISTRIBUTION} -f container/Containerfile.builder.${DISTRIBUTION}
}

build_rpm() {
    mkdir build
    podman run -it \
        -v $(pwd)/scripts:/build/scripts \
        -v $(pwd)/spec:/build/spec \
        -v $(pwd)/build:/build/build \
        -e RELEASE_VERSION=${RELEASE_VERSION:-1} \
        -e VERSION=${VERSION:-master} \
        -e DISTRIBUTION=${DISTRIBUTION} whispercpp-builder:${DISTRIBUTION} sh -c "${CMDS}"
    # echo $CMDS
}


get_opts "$@"

SUCCESS_MESSAGE="Builds successful."


if [ -z "${MODELS}" ]; then
    echo "Error! No MODELS defined. Stop."
    list_help
    exit
elif [ -z "${DISTRIBUTION}" ]; then
    echo "Error! No distribution defined. Stop."
    list_help
    exit
else
    prepare_builder
    for model in ${MODELS}; do
        echo "Build ${model}!"
        CMDS="$CMDS /build/scripts/build-model.sh ${model} &&"
    done
    CMDS="$CMDS echo \"$SUCCESS_MESSAGE\""
    build_rpm
fi
