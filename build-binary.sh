#!/bin/bash


# CMD is the shell-script name without directory (basename)
CMD="${0##*/}"


list_help() {
    echo ""
    echo "Usage: ./build-binary.sh -d DIST -v VERSION -m MODE -r RELEASE BINARY"
    echo ""
    echo "Mandatory: BINARY           whispercpp, whispercpp-cublas"
    echo "Mandatory: [-d] DIST        el8, el9"
    echo "Optional:  [-m] MODE        static, shared        (Default: static)"
    echo "Optional:  [-v] VERSION     Branch/Tag            (Default: master)"
    echo "Optional:  [-r] RELEASE     Number                (Default: 1)"
    echo ""
}

get_opts() {
    SOPTS="m:d:r:v:"
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
            -m)
                # printf "[-m] MODE: %s\n" "$2"
                MODE=${2:-static}
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

    COUNT_CUBLAS=0
    COUNT_NOCUBLAS=0
    nargs=$#
    # printf "remaining %d args :\n" "$nargs"
    for ((i=0; i<nargs; ++i)); do
        # printf "Build rpm %d: %s\n" $((i + 1)) "$1"
        PACKAGES="${PACKAGES} ${1}"
        if [[ "${1}" == *"cublas"* ]]; then
            COUNT_CUBLAS=$((COUNT_CUBLAS+1))
        else
            COUNT_NOCUBLAS=$((COUNT_NOCUBLAS+1))
        fi
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
        -e BUILD_MODE=${MODE:-static} \
        -e RELEASE_VERSION=${RELEASE_VERSION:-1} \
        -e VERSION=${VERSION:-master} \
        -e DISTRIBUTION=${DISTRIBUTION} whispercpp-builder:${DISTRIBUTION} sh -c "${CMDS}"
    # echo $CMDS
}


get_opts "$@"

SUCCESS_MESSAGE="Builds successful."


# echo "COUNT_CUBLAS: ${COUNT_CUBLAS}"
# echo "COUNT_NOCUBLAS: ${COUNT_NOCUBLAS}"

if [ ${COUNT_CUBLAS} -gt 0 ] && [ ${COUNT_NOCUBLAS} -gt 0 ]; then
    echo "Error! Packages with and without cublas defined. Stop"
    exit
fi


if [ -z "${PACKAGES}" ]; then
    echo "Error! No packages defined. Stop."
    list_help
    exit
elif [ -z "${DISTRIBUTION}" ]; then
    echo "Error! No distribution defined. Stop."
    list_help
    exit
else
    if [ "${MODE:-static}" == "shared" ]; then
        echo "Info: Build shared."
        if [[ "$PACKAGES" == *"libwhisper"* ]]; then
            if [[ "$PACKAGES" == *"cublas"* ]]; then
                echo "Info: libwhisper-cublas already specified."
            else
                echo "Info: libwhisper already specified."
            fi
        else
            if [[ "$PACKAGES" == *"cublas"* ]]; then
                PACKAGES="${PACKAGES} libwhisper-cublas"
                echo "Info: Added libwhisper-cublas."
            else
                PACKAGES="${PACKAGES} libwhisper"
                echo "Info: Added libwhisper."
            fi
        fi
    elif [ "${MODE:-static}" == "static" ]; then
        echo "Info: Build static."
        if [[ "$PACKAGES" == *"libwhisper"* ]]; then
            echo "Error! Can't build static library libwhisper/libwhisper-cublas."
            exit
        fi
    fi
    prepare_builder
    for package in ${PACKAGES}; do
        echo "Build ${package}!"
        CMDS="$CMDS /build/scripts/build-rpm.sh ${package} &&"
    done
    CMDS="$CMDS echo \"$SUCCESS_MESSAGE\""
    build_rpm
fi
