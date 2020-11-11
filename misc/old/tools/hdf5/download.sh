#!/bin/sh

SCRIPT_DIR=$(cd "$(dirname $0)"; pwd)
. $SCRIPT_DIR/../util.sh
. $SCRIPT_DIR/version.sh
set_prefix

if [ -f $SOURCE_DIR/hdf5-$HDF5_VERSION.tar.bz2 ]; then :; else
  check wget -O $SOURCE_DIR/hdf5-$HDF5_VERSION.tar.bz2 http://exa.phys.s.u-tokyo.ac.jp/archive/source/hdf5-$HDF5_VERSION.tar.bz2
fi
