#!/bin/sh

SCRIPT_DIR=$(cd "$(dirname $0)"; pwd)
. $SCRIPT_DIR/../util.sh
. $SCRIPT_DIR/version.sh
set_prefix

sh $SCRIPT_DIR/download.sh

cd $BUILD_DIR
if [ -d hdf5-$HDF5_VERSION ]; then :; else
  tar jxf $SOURCE_DIR/hdf5-$HDF5_VERSION.tar.bz2
fi
