#!/bin/sh

SCRIPT_DIR=$(cd "$(dirname $0)"; pwd)
. $SCRIPT_DIR/../util.sh
. $SCRIPT_DIR/version.sh
set_prefix

cd $BUILD_DIR
if [ -d ignition-$IGNITION_VERSION ]; then :; else
  check tar zxf $SOURCE_DIR/ignition-$IGNITION_VERSION.tar.gz
  cd ignition-$IGNITION_VERSION
fi
