#!/bin/sh

SCRIPT_DIR=$(cd "$(dirname $0)"; pwd)
. $SCRIPT_DIR/../util.sh
. $SCRIPT_DIR/version.sh
set_prefix

cd $BUILD_DIR
if [ -d openmx$OPENMX_VERSION ]; then :; else
  if [ -f $HOME/source/openmx$OPENMX_VERSION_MAJOR.tar.gz ]; then
    check tar zxf $HOME/source/openmx$OPENMX_VERSION_MAJOR.tar.gz
  else
      check wget -O - "http://www.openmx-square.org/openmx$OPENMX_VERSION_MAJOR.tar.gz" | tar zxf -
  fi
  cd openmx$OPENMX_VERSION_MAJOR/source
  if [ -f $HOME/source/openmx-patch$OPENMX_VERSION.tar.gz ]; then
    check tar zxf $HOME/source/openmx-patch$OPENMX_VERSION.tar.gz
  else
    check wget -O - "http://www.openmx-square.org/bugfixed/$OPENMX_VERSION_DATE/patch$OPENMX_VERSION.tar.gz" | tar zxf -
  fi
fi
