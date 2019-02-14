#!/bin/sh

SCRIPT_DIR=$(cd "$(dirname $0)"; pwd)
. $SCRIPT_DIR/../util.sh
. $SCRIPT_DIR/version.sh
set_prefix

sh $SCRIPT_DIR/download.sh

cd $BUILD_DIR
if [ -d komega-$KOMEGA_VERSION ]; then :; else
  mkdir -p komega-$KOMEGA_VERSION
  check tar zxf $SOURCE_DIR/komega-${KOMEGA_VERSION}.tar.gz -C komega-$KOMEGA_VERSION --strip-components=1
fi
