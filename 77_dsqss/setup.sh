#!/bin/sh

SCRIPT_DIR=$(cd "$(dirname $0)"; pwd)
. $SCRIPT_DIR/../util.sh
. $SCRIPT_DIR/version.sh
set_prefix

cd $BUILD_DIR
if [ -d dsqss-v$DSQSS_VERSION ]; then :; else
  check mkdir -p dsqss-v$DSQSS_VERSION
  if [ -f $SOURCE_DIR/dsqss-$DSQSS_VERSION.tar.gz ]; then
    check tar zxf $SOURCE_DIR/dsqss-$DSQSS_VERSION.tar.gz
  else
    if [ -f dsqss-$DSQSS_VERSION.tar.gz ]; then :; else
      check wget https://github.com/issp-center-dev/dsqss/releases/download/v${DSQSS_VERSION}/dsqss-v${DSQSS_VERSION}.tar.gz -O dsqss-v${DSQSS_VERSION}.tar.gz
    fi
    check tar zxf dsqss-v${DSQSS_VERSION}.tar.gz
  fi
  cd dsqss-v${DSQSS_VERSION}
  cp doc/DSQSS_jp.pdf .
  cp doc/DSQSS_en.pdf .
fi
