#!/bin/sh

SCRIPT_DIR=$(cd "$(dirname $0)"; pwd)
. $SCRIPT_DIR/../util.sh
. $SCRIPT_DIR/version.sh
set_prefix

cd $BUILD_DIR
if [ -d Komega-$KOMEGA_VERSION ]; then :; else
  if [ -f $SOURCE_DIR/Komega-$KOMEGA_VERSION.tar.gz ]; then
    check tar zxf $SOURCE_DIR/Komega-$KOMEGA_VERSION.tar.gz
  else
    if [ -f Komega-$KOMEGA_VERSION.tar.gz ]; then :; else
      check wget https://github.com/issp-center-dev/Komega/archive/v${KOMEGA_VERSION}.tar.gz -O Komega-${KOMEGA_VERSION}.tar.gz
    fi
    check tar zxf Komega-${KOMEGA_VERSION}.tar.gz
  fi
  cd Komega-${KOMEGA_VERSION}
  cp doc/komega.pdf .
  cp doc/ShiftKSoft.pdf .
fi
