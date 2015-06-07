#!/bin/sh

SCRIPT_DIR=$(cd "$(dirname $0)"; pwd)
. $SCRIPT_DIR/../util.sh
. $SCRIPT_DIR/version.sh
set_prefix

cd $BUILD_DIR
if [ -d gromacs-$GROMACS_VERSION ]; then :; else
  if [ -f $SOURCE_DIR/gromacs_$GROMACS_VERSION.orig.tar.gz ]; then
    check tar zxf $SOURCE_DIR/gromacs_$GROMACS_VERSION.orig.tar.gz
  else
      check wget http://http.debian.net/debian/pool/main/g/gromacs/gromacs_$GROMACS_VERSION.orig.tar.gz
    check tar zxf gromacs_$GROMACS_VERSION.orig.tar.gz
  fi
fi
