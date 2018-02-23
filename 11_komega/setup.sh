#!/bin/sh

SCRIPT_DIR=$(cd "$(dirname $0)"; pwd)
. $SCRIPT_DIR/../util.sh
. $SCRIPT_DIR/version.sh
set_prefix

cd $BUILD_DIR
if [ -d komega-$KOMEGA_VERSION ]; then :; else
  if [ -f $SOURCE_DIR/komega-$KOMEGA_VERSION.tar.gz ]; then
    mkdir -p komega-$KOMEGA_VERSION
    check tar zxf $SOURCE_DIR/komega-$KOMEGA_VERSION.tar.gz -C komega-$KOMEGA_VERSION --strip-components=1
  else
    if [ -f komega-$KOMEGA_VERSION.tar.gz ]; then :; else
      check wget https://github.com/issp-center-dev/Komega/archive/v${KOMEGA_VERSION}.tar.gz -O komega-${KOMEGA_VERSION}.tar.gz
    fi
    mkdir -p komega-$KOMEGA_VERSION
    check tar zxf komega-${KOMEGA_VERSION}.tar.gz -C komega-$KOMEGA_VERSION --strip-components=1
  fi
  cd komega-${KOMEGA_VERSION}
fi
