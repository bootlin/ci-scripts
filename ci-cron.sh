#!/bin/bash
#
# Skia < skia AT libskia DOT so >
#
# Beerware licensed software - 2017
#

ssh ci@build.free-electrons.com './launch_builds.sh'

rsync -ravzP ci@build.free-electrons.com:storage/builds /srv/downloads/
rsync -ravzP ci@build.free-electrons.com:storage/rootfs /srv/downloads/

cd $HOME/custom_tests_tool

git pull

source env/bin/activate

pip install --upgrade -r requirements.txt

./ctt.py -b all
./ctt.py -b all --tree next



