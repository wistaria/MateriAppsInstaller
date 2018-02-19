#!/bin/sh

SCRIPT_DIR=$(cd "$(dirname $0)"; pwd)
. $SCRIPT_DIR/../util.sh
set_prefix
. $PREFIX_TOOL/env.sh
. $SCRIPT_DIR/version.sh

HDF5VARS_SH=$PREFIX_TOOL/hdf5/hdf5vars-$HDF5_VERSION-$HDF5_MA_REVISION.sh
rm -f $PREFIX_TOOL/env.d/hdf5vars.sh
ln -s $HDF5VARS_SH $PREFIX_TOOL/env.d/hdf5vars.sh
