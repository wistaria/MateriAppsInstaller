#!/bin/sh

SCRIPT_DIR=$(cd "$(dirname $0)"; pwd)
. $SCRIPT_DIR/../util.sh
. $SCRIPT_DIR/version.sh
set_prefix

DSQSS_VERSION_ORIG=$(echo $DSQSS_VERSION | sed 's/+/-/g')
DSQSS_VERSION_SHORT=$(echo $DSQSS_VERSION | cut -d + -f 1)

cd $BUILD_DIR
if [ -d dsqss-$DSQSS_VERSION ]; then :; else
  if [ -f $SOURCE_DIR/dsqss_$DSQSS_VERSION.orig.tar.gz ]; then
    check tar zxf $SOURCE_DIR/dsqss_$DSQSS_VERSION.orig.tar.gz
  else
    check wget $MALIVE_REPOSITORY/dsqss_$DSQSS_VERSION.orig.tar.gz
    check tar zxf dsqss_$DSQSS_VERSION.orig.tar.gz
  fi
  cd dsqss-$DSQSS_VERSION
  if [ -f $SOURCE_DIR/dsqss_$DSQSS_VERSION-$DSQSS_MA_REVISION.diff.gz ]; then
    check gzip -dc $SOURCE_DIR/dsqss_$DSQSS_VERSION-$DSQSS_MA_REVISION.diff.gz | patch -p1
  else
    check wget $MALIVE_REPOSITORY/dsqss_$DSQSS_VERSION-$DSQSS_MA_REVISION.diff.gz
    check gzip -dc dsqss_$DSQSS_VERSION-$DSQSS_MA_REVISION.diff.gz | patch -p1
  fi
  chmod +x dsqss/dsqss-$DSQSS_VERSION_SHORT/install-sh
fi
