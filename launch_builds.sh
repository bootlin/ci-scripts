#!/bin/bash

cd $(dirname $0)

echo "Triggering rootfs build"
./buildrootfs.sh

echo "Triggering kernels build"
cd $HOME/kernel-builder/
git pull
echo "  Updating sources"
./update-source-tarball.sh all
echo "  Launching builds"
for d in $(ls defconfigs/*/*); do 
    ./build.py -d $d; 
done

cd

