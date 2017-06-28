#!/bin/bash

echo "Triggering builds on Build server"
ssh ci@build.free-electrons.com './ci-scripts/launch_builds.sh'

echo "Fetching storage from Build server"
rsync -ravzP ci@build.free-electrons.com:storage/builds /srv/downloads/
rsync -ravzP ci@build.free-electrons.com:storage/rootfs /srv/downloads/

echo "Launching ctt to send custom jobs"
cd $HOME/custom_tests_tool
echo "  Updating ctt"
git pull
source env/bin/activate
pip install --upgrade -r requirements.txt
echo "  ctt up to date"

echo "  launching all jobs for mainline"
./ctt.py -b all --tree mainline
echo "  launching all jobs for next"
./ctt.py -b all --tree next



