#!/bin/sh

SCRIPT_DIR=$(cd "$(dirname $0)"; pwd)
. $SCRIPT_DIR/../util.sh
. $SCRIPT_DIR/version.sh
set_prefix
set_build_dir

. $PREFIX_OPT/env.sh
PREFIX_FRONTEND="$PREFIX_OPT/Linux-x86_64"
PREFIX_BACKEND="$PREFIX_OPT/Linux-s64fx"
export LANG C

# for frontend

cd $BUILD_DIR
rm -rf szip-$SZIP_VERSION
if [ -f $HOME/source/szip-$SZIP_VERSION.tar.gz ]; then
  check tar zxf $HOME/source/szip-$SZIP_VERSION.tar.gz
else
  check wget -O - http://www.hdfgroup.org/ftp/lib-external/szip/$SZIP_VERSION/src/szip-$SZIP_VERSION.tar.gz | tar zxf -
fi
cd szip-$SZIP_VERSION
check ./configure --prefix=$PREFIX_FRONTEND
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
check ./configure --prefix=$PREFIX_FRONTEND --with-szlib=$PREFIX_FROTEND
check make -j4
$SUDO make install

# for backend

cd $BUILD_DIR
rm -rf hdf5-$HDF5_VERSION
if [ -f $HOME/source/hdf5-$HDF5_VERSION.tar.bz2 ]; then
  check tar jxf $HOME/source/hdf5-$HDF5_VERSION.tar.bz2
else
  check wget -O - http://www.hdfgroup.org/ftp/HDF5/releases/hdf5-$HDF5_VERSION/src/hdf5-$HDF5_VERSION.tar.bz2
fi
cd hdf5-$HDF5_VERSION
check cp $SCRIPT_DIR/fx10-config.cache config.cache
CC="fccpx -O2 -Xg" check ./configure --cache-file=config.cache --prefix=$PREFIX_BACKEND --target=sparc-linux --host=x86 --enable-threadsafe --with-pthread=yes
cd src
check make -j4 H5make_libsettings H5detect
pjsub --interact $SCRIPT_DIR/fx10-batch.sh
cd ..
check make -j4
$SUDO make install

make distclean
check cp $SCRIPT_DIR/fx10-config.cache config.cache
CC="fccpx -O2 -Xg -KPIC" check ./configure --cache-file=config.cache --prefix=$PREFIX_BACKEND --target=sparc-linux --host=x86 --enable-threadsafe --with-pthread=yes
cd src
check make -j4 H5make_libsettings H5detect
pjsub --interact $SCRIPT_DIR/fx10-batch.sh
cd ..
check make -j4
check fccpx -Xg -KPIC -shared -o libhdf5.so H5.o H5checksum.o H5dbg.o H5lib_settings.o H5system.o H5timer.o H5trace.o H5[A-Z]*.o
$SUDO cp -fp libhdf5.so $PREFIX_BACKEND/lib
cd ../hl/src
check make -j4
check fccpx -Xg -KPIC -shared -o libhdf5_hl.so  H5*.o
$SUDO cp -fp libhdf5_hl.so $PREFIX_BACKEND/lib
