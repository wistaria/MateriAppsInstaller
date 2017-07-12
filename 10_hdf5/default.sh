#!/bin/sh

SCRIPT_DIR=$(cd "$(dirname $0)"; pwd)
. $SCRIPT_DIR/../util.sh
set_prefix
. $PREFIX_TOOL/env.sh
. $SCRIPT_DIR/version.sh

$SUDO_TOOL /bin/true
LOG=$BUILD_DIR/hdf5-$HDF5_VERSION-$HDF5_MA_REVISION.log
PREFIX=$PREFIX_TOOL/hdf5/hdf5-$HDF5_VERSION-$HDF5_MA_REVISION

if [ -d $PREFIX ]; then
  echo "Error: $PREFIX exists"
  exit 127
fi

sh $SCRIPT_DIR/setup.sh
rm -rf $LOG

cd $BUILD_DIR/hdf5-$HDF5_VERSION
echo "[make]" | tee -a $LOG
check ./configure --prefix=$PREFIX --enable-threadsafe --with-pthread=yes | tee -a $LOG
echo "[make]" | tee -a $LOG
make | tee -a $LOG
echo "[make install]" | tee -a $LOG
$SUDO_TOOL make install | tee -a $LOG

cat << EOF > $BUILD_DIR/hdf5vars.sh
# hdf5 $(basename $0 .sh) $HDF5_VERSION $HDF5_MA_REVISION $(date +%Y%m%d-%H%M%S)
export HDF5_ROOT=$PREFIX
export HDF5_VERSION=$HDF5_VERSION
export HDF5_MA_REVISION=$HDF5_MA_REVISION
export PATH=\$HDF5_ROOT/bin:\$PATH
export LD_LIBRARY_PATH=\$HDF5_ROOT/lib:\$LD_LIBRARY_PATH
EOF
HDF5VARS_SH=$PREFIX_TOOL/hdf5/hdf5vars-$HDF5_VERSION-$HDF5_MA_REVISION.sh
$SUDO_TOOL rm -f $HDF5VARS_SH
$SUDO_TOOL cp -f $BUILD_DIR/hdf5vars.sh $HDF5VARS_SH
rm -f $BUILD_DIR/hdf5vars.sh
$SUDO_TOOL cp -f $LOG $PREFIX_TOOL/hdf5/
