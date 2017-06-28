#!/bin/bash

ssh ci@build.free-electrons.com './ci-scripts/launch_builds.sh'

rsync -ravzP ci@build.free-electrons.com:storage/builds /srv/downloads/
rsync -ravzP ci@build.free-electrons.com:storage/rootfs /srv/downloads/

cd $HOME/custom_tests_tool

git pull

source env/bin/activate

pip install --upgrade -r requirements.txt

./ctt.py -b all
./ctt.py -b all --tree next



