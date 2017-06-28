#!/bin/bash

cd $(dirname $0)

./buildrootfs.sh

cd $HOME/kernel-builder/
git pull
./update-source-tarball.sh all
for d in $(ls defconfigs/*/*); do 
    ./build.py -d $d; 
done

cd

