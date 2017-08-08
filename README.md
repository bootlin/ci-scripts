# CI scripts

## ci-cron.sh

This runs on the LAVA VM, under whatever user you want (currently ctt). This
user must have access to the build server with the 'ci' login and an SSH key.

This script will call the `launch_builds.sh` script on the build server, then
trigger `ctt.py` to send custom jobs.

This script is launched daily.

## launch_builds.sh

This must be run on the build server. This script first trigger the build of 
the rootfs, then the build of the custom kernels.

It makes use of our buildroot-ci project for the rootfs, and our kernel-builder
project for the kernels.   
Both projects must be available in `$HOME`.

Built artifacts are then available in `$HOME/storage`.

This script is called by `ci-cron.sh`.

## buildrootfs.sh

This triggers if needed (no artifacts, or new commits) a build of our custom
rootfs.

The `buildroot-ci` project must be available in `$HOME`.

This script is called by `launch_builds.sh`.
