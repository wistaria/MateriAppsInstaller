#!/bin/sh

SCRIPT_DIR=$(cd "$(dirname $0)"; pwd)
. $SCRIPT_DIR/../util.sh
set_prefix
. $PREFIX_TOOL/env.sh
. $SCRIPT_DIR/version.sh

VERSION_MAJOR=$(echo $OPENMPI_VERSION | cut -d . -f 1,2)

cd $BUILD_DIR
if [ -d openmpi-$OPENMPI_VERSION ]; then :; else
  if [ -f $SOURCE_DIR/openmpi-$OPENMPI_VERSION.tar.bz2 ]; then
    check tar jxf $SOURCE_DIR/openmpi-$OPENMPI_VERSION.tar.bz2
  elif [ -f openmpi-$OPENMPI_VERSION.tar.bz2 ]; then
    check tar jxf openmpi-$OPENMPI_VERSION.tar.bz2
  else
    check wget https://www.open-mpi.org/software/ompi/v$VERSION_MAJOR/downloads/openmpi-$OPENMPI_VERSION.tar.bz2
    check tar jxf openmpi-$OPENMPI_VERSION.tar.bz2
  fi
fi
