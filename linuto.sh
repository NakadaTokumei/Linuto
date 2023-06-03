#!/bin/bash
echo "=================================="
echo "              Linuto"
echo "       Made by Nakada Tokumei"
echo "=================================="

function error_exit() {
    echo $2
    exit -1
}

# TODO
function get_requirements() {
    if [ ! -n ${which apt-get} ]; then
        apt-get update
        apt-get install -y bison flex build-essential libelf-dev
    fi
}

function add_kernel() {
    if [ ! -d linux/ ]; then
        mkdir linux/
    fi

    if [ ! -d linux/${linux_ver}/ ]; then
        tar xvf $1
        if [ $? -ne 0 ]; then
            error_exit "Failed to extract tar.gz file"
        fi
        mv $linux_path/ linux/$linux_ver
    fi

    cd linux/$linux_ver

    # default config
    ARCH=x86 CROSS_COMPILE=x86_64-linux-gnu- make x86_64-defconfig 

    # User config
    ARCH=x86 CROSS_COMPILE=x86_64-linux-gnu- make menuconfig

    cd ..
}

function build_kernel() {
    if [ ! -d linux/$1 ]; then
        error_exit "Version Not found"
    fi
    
    cd linux/$1

    ARCH=x86 CROSS_COMPILE=x86_64-linux-gnu- make bzImage

    if [ ! -d ../../image/$1 ]; then
        mkdir -p ../../image/$1
    fi

    if [ -f arch/x86/boot/bzImage ]; then
        cp arch/x86/boot/bzImage ../../image/$1
    fi

    cd ../../

    docker build . -t linuto --build-arg LINUX_VERSION=$1
}

function run_kernel() {
    clear
    docker run  -t -i -p 9898:9898 --privileged linuto
}

get_requirements

case $1 in
    "add_kernel")
        if [ $# -lt 2 ]; then
            error_exit "You don't give tar.gz file"
        fi
        linux_path=$(echo $2 | awk '{split($0, parse_str, ".tar"); print parse_str[1]}')
        linux_ver=$(echo $linux_path | awk '{split($0, parse_str, "-"); print parse_str[2]}')
        add_kernel $2
        ;;
    "build")
        if [ $# -lt 2 ]; then
            error_exit "You don't give version"
        fi
        build_kernel $2
        ;;
    "run")
        run_kernel
        ;;
    *)
        echo "Wrong Arguments"
        ;;
esac