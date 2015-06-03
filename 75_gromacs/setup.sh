#!/bin/sh

SCRIPT_DIR=$(cd "$(dirname $0)"; pwd)
. $SCRIPT_DIR/../util.sh
. $SCRIPT_DIR/version.sh
set_prefix

cd $BUILD_DIR
if [ -d gromacs-$GROMACS_VERSION ]; then :; else
  if [ -f $SOURCE_DIR/gromacs-$GROMACS_VERSION.tar.gz ]; then
    check tar zxf $SOURCE_DIR/gromacs-$GROMACS_VERSION.tar.gz
  else
    check wget ftp://ftp.gromacs.org/pub/gromacs/gromacs-$GROMACS_VERSION.tar.gz
    check tar zxf gromacs-$GROMACS_VERSION.tar.gz
  fi
fi
