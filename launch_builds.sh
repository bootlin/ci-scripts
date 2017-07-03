#!/bin/bash

RETURN_VALUE=0
cd $(dirname $0)
MAIN=$(pwd)

git pull

echo "Triggering rootfs build"
if ! ./buildrootfs.sh 2>&1 > $MAIN/buildrootfs.log; then
    RETURN_VALUE=1
fi

echo "Triggering kernels build"
cd $HOME/kernel-builder/
git pull

echo "  Updating sources"
if ! ./update-source-tarball.sh all 2>&1 > $MAIN/update-source-tarball.log; then
    RETURN_VALUE=1
fi

echo "  Launching builds"
for d in $(ls defconfigs/*/*); do
    echo "  Building $d"
    if ! ./build.py -d $d 2>&1 > $MAIN/build_$(sed "s/\//_/g" <<<"$d").log; then
        RETURN_VALUE=1
    fi
done

exit $RETURN_VALUE

