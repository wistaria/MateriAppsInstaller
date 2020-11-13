#!/bin/sh

cd ${GITHUB_WORKSPACE}/apps/tenes
sh install.sh
sh runtest.sh

cd ${GITHUB_WORKSPACE}/apps/komega
sh install.sh
sh runtest.sh

