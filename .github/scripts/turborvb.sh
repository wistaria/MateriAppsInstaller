#!/bin/sh
set -e

cd ${GITHUB_WORKSPACE}/apps/turborvb
MAKE_J=-j4 sh install.sh
sh runtest.sh
