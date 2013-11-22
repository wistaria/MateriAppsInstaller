#!/bin/sh

SCRIPT_DIR=$(cd "$(dirname $0)"; pwd)
. $SCRIPT_DIR/../util.sh
. $SCRIPT_DIR/version.sh
set_prefix
set_build_dir

. $PREFIX_OPT/env.sh

cd $BUILD_DIR
rm -rf szip-$SZIP_VERSION
if [ -f $HOME/source/szip-$SZIP_VERSION.tar.gz ]; then
  check tar zxf $HOME/source/szip-$SZIP_VERSION.tar.gz
else
  check wget -O - http://www.hdfgroup.org/ftp/lib-external/szip/$SZIP_VERSION/src/szip-$SZIP_VERSION.tar.gz | tar zxf -

fi
cd szip-$SZIP_VERSION
check ./configure --prefix=$PREFIX_OPT
check make -j4
$SUDO make install

cd $BUILD_DIR
rm -rf hdf5-$HDF5_VERSION
if [ -f $HOME/source/hdf5-$HDF5_VERSION.tar.bz2 ]; then
  check tar jxf $HOME/source/hdf5-$HDF5_VERSION.tar.bz2
else
  check wget -O - http://www.hdfgroup.org/ftp/HDF5/releases/hdf5-$HDF5_VERSION/src/hdf5-$HDF5_VERSION.tar.bz2
fi
cd hdf5-$HDF5_VERSION
check ./configure --prefix=$PREFIX_OPT --with-szlib=$PREFIX_OPT
check make -j4
$SUDO make install
