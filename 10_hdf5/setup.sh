#!/bin/sh

SCRIPT_DIR=$(cd "$(dirname $0)"; pwd)
. $SCRIPT_DIR/../util.sh
set_prefix
. $PREFIX_TOOL/env.sh
. $SCRIPT_DIR/version.sh

cd $BUILD_DIR
if [ -d hdf5-$HDF5_VERSION ]; then :; else
  if [ -f $SOURCE_DIR/hdf5-$HDF5_VERSION.tar.bz2 ]; then
    check tar jxf $SOURCE_DIR/hdf5-$HDF5_VERSION.tar.bz2
  else
    check wget http://www.hdfgroup.org/ftp/HDF5/releases/hdf5-$HDF5_VERSION/src/hdf5-$HDF5_VERSION.tar.bz2
    tar jxf hdf5-$HDF5_VERSION.tar.bz2
  fi
fi
