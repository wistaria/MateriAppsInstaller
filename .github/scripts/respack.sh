#!/bin/sh

cd ${GITHUB_WORKSPACE}/apps/espresso
sh install.sh
sh link.sh

cd ${GITHUB_WORKSPACE}/apps/respack
sh install.sh
sh runtest.sh
