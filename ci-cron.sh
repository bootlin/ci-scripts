#!/bin/bash

cd $(dirname $0)
MAIN=$(pwd)

echo "Triggering builds on Build server"
if ! ssh ci@build.free-electrons.com './ci-scripts/launch_builds.sh'; then
    echo "There was some errors during the build. Sending an email, but going further"
fi

echo "Fetching storage from Build server"
if  ! rsync -ravz ci@build.free-electrons.com:storage/builds /srv/downloads/ || \
    ! rsync -ravz ci@build.free-electrons.com:storage/rootfs /srv/downloads/ ; then
    echo "There was a problem getting the artifacts from the build server"
fi

echo "Launching ctt to send custom jobs"
cd $HOME/custom_tests_tool
echo "  Updating ctt"
source env/bin/activate
if  ! git pull || \
    ! pip install --upgrade -r requirements.txt ; then
    echo "There was an error getting the latest CTT version"
fi
echo "  ctt up to date"

echo "  launching jobs"
if  ! ./ci_launcher.py -b all; then
    echo "There was an error launching the jobs"
fi
