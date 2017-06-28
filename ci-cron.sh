#!/bin/bash

echo "Triggering builds on Build server"
if ! ssh ci@build.free-electrons.com './ci-scripts/launch_builds.sh' 2>&1 > /tmp/ci_build.log; then
    echo "There was some errors during the build. Sending an email, but going further"
    cat - > /tmp/ci_email <<EOF
Subject: Build error(s) in CI architecture

There was some errors in the daily build of rootfs and/or kernels. You can find
the full log below.

====
EOF
    cat /tmp/ci_build.log >> /tmp/ci_email
    sendmail florent.jacquet@free-electrons.com < /tmp/ci_email
fi

echo "Fetching storage from Build server"
if ! rsync -ravzP ci@build.free-electrons.com:storage/builds /srv/downloads/ || ! rsync -ravzP ci@build.free-electrons.com:storage/rootfs /srv/downloads/; then
    echo "There was a problem getting the artifacts from the build server"
fi

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



