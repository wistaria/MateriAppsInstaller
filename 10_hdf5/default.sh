#!/bin/sh

SCRIPT_DIR=$(cd "$(dirname $0)"; pwd)
. $SCRIPT_DIR/../util.sh
. $SCRIPT_DIR/version.sh
set_prefix

. $PREFIX_TOOL/env.sh
PREFIX=$PREFIX_TOOL/hdf5/hdf5-$HDF5_VERSION

cd $BUILD_DIR
rm -rf hdf5-$HDF5_VERSION
if [ -f $HOME/source/hdf5-$HDF5_VERSION.tar.bz2 ]; then
  check tar jxf $HOME/source/hdf5-$HDF5_VERSION.tar.bz2
else
  check wget -O - http://www.hdfgroup.org/ftp/HDF5/releases/hdf5-$HDF5_VERSION/src/hdf5-$HDF5_VERSION.tar.bz2
fi
cd hdf5-$HDF5_VERSION
check ./configure --prefix=$PREFIX --enable-threadsafe --with-pthread=yes
check make -j4
$SUDO_TOOL make install

cat << EOF > $BUILD_DIR/hdf5vars.sh
export PATH=$PREFIX/bin:\$PATH
export LD_LIBRARY_PATH=$PREFIX/lib:\$LD_LIBRARY_PATH
EOF
HDF5VARS_SH=$PREFIX_TOOL/hdf5/hdf5vars-$HDF5_VERSION.sh
$SUDO_TOOL rm -f $HDF5VARS_SH
$SUDO_TOOL cp -f $BUILD_DIR/hdf5vars.sh $HDF5VARS_SH
