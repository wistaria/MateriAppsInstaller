#!/bin/sh

SCRIPT_DIR=$(cd "$(dirname $0)"; pwd)
. $SCRIPT_DIR/../util.sh
. $SCRIPT_DIR/version.sh
set_prefix

DSQSS_VERSION_ORIG=$(echo $DSQSS_VERSION | sed 's/+/-/g')

cd $BUILD_DIR
if [ -d dsqss-$DSQSS_VERSION ]; then :; else
  if [ -f $SOURCE_DIR/dsqss-$DSQSS_VERSION.zip ]; then
    check unzip $SOURCE_DIR/dsqss-$DSQSS_VERSION.zip
  else
    check wget https://github.com/qmc/dsqss/archive/v$DSQSS_VERSION.zip -O dsqss-$DSQSS_VERSION.zip
    check unzip dsqss-$DSQSS_VERSION.zip
  fi
  if [ $DSQSS_VERSION != $DSQSS_VERSION_ORIG ]; then
    mv dsqss-$DSQSS_VERSION_ORIG dsqss-$DSQSS_VERSION
  fi
  cd dsqss-$DSQSS_VERSION
  PATCHES="runConfigure.patch"
  for p in $PATCHES; do
    patch -p1 < $SCRIPT_DIR/$p
  done
  chmod +x dsqss/dsqss-1.1.17/install-sh
fi
