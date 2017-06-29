#!/bin/bash

MAIL_TO="florent.jacquet@free-electrons.com"
cd $(dirname $0)
MAIN=$(pwd)

echo "Triggering builds on Build server"
if ! ssh ci@build.free-electrons.com './ci-scripts/launch_builds.sh'; then
    echo "There was some errors during the build. Sending an email, but going further"
    cat - > /tmp/ci_email <<EOF
Subject: Build error(s) in CI architecture

There was some errors in the daily build of rootfs and/or kernels.
You can find the logs on the build server in the /home/ci/ci-scripts folder.

EOF
    sendmail $MAIL_TO < /tmp/ci_email
fi

echo "Fetching storage from Build server"
if  ! rsync -ravzP ci@build.free-electrons.com:storage/builds /srv/downloads/ 2>&1 > $MAIN/rsync.log || \
    ! rsync -ravzP ci@build.free-electrons.com:storage/rootfs /srv/downloads/ 2>&1 >> $MAIN/rsync.log; then
    echo "There was a problem getting the artifacts from the build server"
    cat - > /tmp/ci_email <<EOF
Subject: Transfer error(s) in CI architecture

There was some errors to fetch the latest builds.
You can find the logs on the LAVA VM in the /home/ctt/ci-scripts folder.

EOF
    sendmail $MAIL_TO < /tmp/ci_email
fi

echo "Launching ctt to send custom jobs"
cd $HOME/custom_tests_tool
echo "  Updating ctt"
source env/bin/activate
if  ! git pull 2>&1 > $MAIN/git_pull.log || \
    ! pip install --upgrade -r requirements.txt 2>&1 > $MAIN/pip.log; then
    echo "There was an error getting the latest CTT version"
    cat - > /tmp/ci_email <<EOF
Subject: Getting the latest CTT version failed

There was some errors updating CTT in the LAVA VM, either with the \`git pull\`,
or the dependencies installation.
You can find the logs on the LAVA VM in the /home/ctt/ci-scripts folder.

EOF
    sendmail $MAIL_TO < /tmp/ci_email
fi
echo "  ctt up to date"

echo "  launching jobs"
if  ! ./ctt.py -b all --tree mainline 2>&1 > $MAIN/ctt.log || \
    ! ./ctt.py -b all --tree next 2>&1 >> $MAIN/ctt.log; then
    echo "There was an error launching the jobs"
    cat - > /tmp/ci_email <<EOF
Subject: Launching daily jobs failed in CI architecture

There was some errors sending the jobs.
You can find the logs on the LAVA VM in the /home/ctt/ci-scripts folder.

EOF
    sendmail $MAIL_TO < /tmp/ci_email
fi



