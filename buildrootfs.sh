#!/bin/bash
#


cd $HOME/buildroot-ci

git fetch
if ! [ "$(git rev-parse HEAD)" == "$(git rev-parse @{u})" ]; then
    git pull

    if ./build_rootfs.sh defconfig armv4 build armv4 defconfig armv5 build armv5 defconfig armv7 build armv7 defconfig aarch64 build aarch64
    then
        echo "Rootfs built!"
    else
        echo "Rootfs building failed"
    fi
    exit 0
else
    echo "Nothing to update"
    exit 0
fi


