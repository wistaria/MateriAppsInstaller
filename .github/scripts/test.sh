#!/bin/sh

cd ${GITHUB_WORKSPACE}
cd apps
cd tenes
sh install.sh
sh runtest.sh
