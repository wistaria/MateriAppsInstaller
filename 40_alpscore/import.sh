#!/bin/sh

SCRIPT_DIR=$(cd "$(dirname $0)"; pwd)
. $SCRIPT_DIR/../util.sh
. $SCRIPT_DIR/version.sh
set_prefix

FILE="alpscore_$ALPSCORE_VERSION-$ALPSCORE_MA_REVISION.debian.tar.xz"
check wget -O - $MALIVE_REPOSITORY/$FILE | tar zxf - --strip-components=1 debian/patches
