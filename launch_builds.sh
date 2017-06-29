#!/bin/bash

RETURN_VALUE=0
cd $(dirname $0)

git pull

echo "Triggering rootfs build"
if ! ./buildrootfs.sh > buildrootfs.log; then
    RETURN_VALUE=1
fi

echo "Triggering kernels build"
cd $HOME/kernel-builder/
git pull

echo "  Updating sources"
if ! ./update-source-tarball.sh all > update-source-tarball.log; then
    RETURN_VALUE=1
fi

echo "  Launching builds"
for d in $(ls defconfigs/*/*); do
    if ! ./build.py -d $d > build_$d.log; then
        RETURN_VALUE=1
    fi
done

exit $RETURN_VALUE

