#!/bin/bash

RETURN_VALUE=0
cd $(dirname $0)

echo "Triggering rootfs build"
if ! ./buildrootfs.sh; then
    RETURN_VALUE=1
fi

echo "Triggering kernels build"
cd $HOME/kernel-builder/
git pull

echo "  Updating sources"
if ! ./update-source-tarball.sh all; then
    RETURN_VALUE=1
fi

echo "  Launching builds"
for d in $(ls defconfigs/*/*); do 
    if ! ./build.py -d $d; then
        RETURN_VALUE=1
    fi
done

exit $RETURN_VALUE

