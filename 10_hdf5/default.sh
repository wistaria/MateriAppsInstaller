#!/bin/sh

SCRIPT_DIR=$(cd "$(dirname $0)"; pwd)
. $SCRIPT_DIR/../util.sh
. $SCRIPT_DIR/version.sh
set_prefix

. $PREFIX_TOOL/env.sh
LOG=$BUILD_DIR/hdf5-$HDF5_VERSION-$HDF5_MA_REVISION.log
rm -rf $LOG

PREFIX=$PREFIX_TOOL/hdf5/hdf5-$HDF5_VERSION-$HDF5_MA_REVISION

if [ -d $PREFIX ]; then
  echo "Error: $PREFIX exists"
  exit 127
fi

sh $SCRIPT_DIR/setup.sh

cd $BUILD_DIR/hdf5-$HDF5_VERSION
echo "[make]" | tee -a $LOG
check ./configure --prefix=$PREFIX --enable-threadsafe --with-pthread=yes | tee -a $LOG
echo "[make]" | tee -a $LOG
make | tee -a $LOG
echo "[make install]" | tee -a $LOG
make install | tee -a $LOG

cat << EOF > $BUILD_DIR/hdf5vars.sh
# hdf5 $(basename $0 .sh) $HDF5_VERSION $HDF5_MA_REVISION $(date +%Y%m%d-%H%M%S)
export HDF5_ROOT=$PREFIX
export HDF5_VERSION=$HDF5_VERSION
export HDF5_MA_REVISION=$HDF5_MA_REVISION
export PATH=\$HDF5_ROOT/bin:\$PATH
export LD_LIBRARY_PATH=\$HDF5_ROOT/lib:\$LD_LIBRARY_PATH
EOF
HDF5VARS_SH=$PREFIX_TOOL/hdf5/hdf5vars-$HDF5_VERSION-$HDF5_MA_REVISION.sh
rm -f $HDF5VARS_SH
cp -f $BUILD_DIR/hdf5vars.sh $HDF5VARS_SH
rm -f $BUILD_DIR/hdf5vars.sh
cp -f $LOG $PREFIX_TOOL/hdf5/
