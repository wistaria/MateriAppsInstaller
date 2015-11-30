#!/bin/sh

SCRIPT_DIR=$(cd "$(dirname $0)"; pwd)
. $SCRIPT_DIR/../util.sh
. $SCRIPT_DIR/version.sh
set_prefix

ALPS_VERSION_ORIG=$(echo $ALPS_VERSION | sed 's/-/~/g')
cd $BUILD_DIR
if [ -d alps-$ALPS_VERSION ]; then :; else
  if [ -f $SOURCE_DIR/alps_$ALPS_VERSION_ORIG.orig.tar.gz ]; then
    check tar zxf $SOURCE_DIR/alps_$ALPS_VERSION_ORIG.orig.tar.gz
  else
    if [ -f alps_$ALPS_VERSION_ORIG.orig.tar.gz ]; then :; else
      check wget $MALIVE_REPOSITORY/alps_$ALPS_VERSION_ORIG.orig.tar.gz
    fi
    check tar zxf alps_$ALPS_VERSION_ORIG.orig.tar.gz | tar zxf -
  fi
  mv alps_$ALPS_VERSION_ORIG alps-$ALPS_VERSION
  cd alps-$ALPS_VERSION
  # patch -p1 < $SCRIPT_DIR/alps-$ALPS_VERSION-$ALPS_PATCH_VERSION.patch
fi
