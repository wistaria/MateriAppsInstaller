#!/bin/sh

SCRIPT_DIR=$(cd "$(dirname $0)"; pwd)
. $SCRIPT_DIR/../util.sh
. $SCRIPT_DIR/version.sh
set_prefix

sh $SCRIPT_DIR/download.sh

cd $BUILD_DIR
if [ -d julia-$JULIA_VERSION ]; then :; else
  mkdir -p julia-$JULIA_VERSION
  check tar zxf $SOURCE_DIR/julia-$JULIA_VERSION-full.tar.gz -C julia-$JULIA_VERSION --strip-components=1
fi
