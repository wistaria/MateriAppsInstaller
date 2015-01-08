#!/bin/sh

SCRIPT_DIR=$(cd "$(dirname $0)"; pwd)
. $SCRIPT_DIR/../util.sh
. $SCRIPT_DIR/version.sh
set_prefix

. $PREFIX_TOOL/env.sh
PREFIX=$PREFIX_TOOL/hdf5/hdf5-$HDF5_VERSION-$HDF5_PATCH_VERSION
PREFIX_FRONTEND="$PREFIX/Linux-x86_64"
PREFIX_BACKEND="$PREFIX/Linux-s64fx"
export LANG C

# for frontend

cd $BUILD_DIR
rm -rf hdf5-$HDF5_VERSION
if [ -f $HOME/source/hdf5-$HDF5_VERSION.tar.bz2 ]; then
  check tar jxf $HOME/source/hdf5-$HDF5_VERSION.tar.bz2
else
  check wget -O - http://www.hdfgroup.org/ftp/HDF5/releases/hdf5-$HDF5_VERSION/src/hdf5-$HDF5_VERSION.tar.bz2
fi
cd hdf5-$HDF5_VERSION
check ./configure --prefix=$PREFIX_FRONTEND --enable-threadsafe --with-pthread=yes
check make -j4
$SUDO_TOOL make install

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
check env CC="fccpx -O2 -Xg" ./configure --cache-file=config.cache --prefix=$PREFIX_BACKEND --target=sparc-linux --host=x86
cd src
check make -j4 H5make_libsettings H5detect
check pjsub --interact $SCRIPT_DIR/fx10-script.sh
touch touch H5lib_settings.c H5Tinit.c
cd ..
check make -j4
$SUDO_TOOL make install

make distclean
check cp $SCRIPT_DIR/fx10-config.cache config.cache
check env CC="fccpx -O2 -Xg -KPIC" ./configure --cache-file=config.cache --prefix=$PREFIX_BACKEND --target=sparc-linux --host=x86
cd src
check make -j4 H5make_libsettings H5detect
check pjsub --interact $SCRIPT_DIR/fx10-script.sh
touch touch H5lib_settings.c H5Tinit.c
check make -j4
check fccpx -Xg -KPIC -shared -o libhdf5.so H5.o H5checksum.o H5dbg.o H5lib_settings.o H5system.o H5timer.o H5trace.o H5[A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,P,Q,R,S,T,U,V,W,X,Y,Z]*.o
$SUDO_TOOL cp -fp libhdf5.so $PREFIX_BACKEND/lib
cd ../hl/src
check make -j4
check fccpx -Xg -KPIC -shared -o libhdf5_hl.so H5*.o
$SUDO_TOOL cp -fp libhdf5_hl.so $PREFIX_BACKEND/lib

cat << EOF > $BUILD_DIR/hdf5vars.sh
OS=\$(uname -s)
ARCH=\$(uname -m)
export HDF5_ROOT=$PREFIX
export PATH=\$HDF5_ROOT/\$OS-\$ARCH/bin:\$PATH
export LD_LIBRARY_PATH=\$HDF5_ROOT/\$OS-\$ARCH/lib:\$LD_LIBRARY_PATH
EOF
HDF5VARS_SH=$PREFIX_TOOL/hdf5/hdf5vars-$HDF5_VERSION-$HDF5_PATCH_VERSION.sh
$SUDO_TOOL rm -f $HDF5VARS_SH
$SUDO_TOOL cp -f $BUILD_DIR/hdf5vars.sh $HDF5VARS_SH
