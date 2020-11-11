#!/bin/sh

SCRIPT_DIR=$(cd "$(dirname $0)"; pwd)
. $SCRIPT_DIR/../util.sh
set_prefix
. $PREFIX_TOOL/env.sh
. $SCRIPT_DIR/version.sh

# cd $BUILD_DIR
# rm -rf szip-$SZIP_VERSION
# if [ -f $HOME/source/szip-$SZIP_VERSION.tar.gz ]; then
#   check tar zxf $HOME/source/szip-$SZIP_VERSION.tar.gz
# else
#   check wget -O - http://www.hdfgroup.org/ftp/lib-external/szip/$SZIP_VERSION/src/szip-$SZIP_VERSION.tar.gz | tar zxf -
# fi
# cd szip-$SZIP_VERSION
# CC=xlc CXX=xlC CFLAGS="-O2" CXXFLAGS="-O2" check ./configure --prefix=$PREFIX_TOOL
# check gmake -j2
# gmake install
# check gmake distclean
# CC=xlc CXX=xlC CFLAGS="-O2 -qpic" CXXFLAGS="-O2 -qpic" check ./configure --prefix=$PREFIX_TOOL
# check gmake -j2
# check xlc -G -o libsz.so src/rice.o src/sz_api.o src/encoding.o
# cp -fp libsz.so $PREFIX_TOOL/lib

cd $BUILD_DIR
rm -rf hdf5-$HDF5_VERSION
if [ -f $HOME/source/hdf5-$HDF5_VERSION.tar.bz2 ]; then
  check tar jxf $HOME/source/hdf5-$HDF5_VERSION.tar.bz2
else
  check wget -O - http://www.hdfgroup.org/ftp/HDF5/releases/hdf5-$HDF5_VERSION/src/hdf5-$HDF5_VERSION.tar.bz2 | tar jxf -
fi
cd hdf5-$HDF5_VERSION
CC=xlc CXX=xlC CFLAGS="-O2" CXXFLAGS="-O2" check ./configure --prefix=$PREFIX_TOOL --with-szlib=$PREFIX_TOOL
check gmake -j2
gmake install
gmake distclean
CC=xlc CXX=xlC CFLAGS="-O2 -qpic" CXXFLAGS="-O2 -qpic" check ./configure --prefix=$PREFIX_TOOL --with-szlib=$PREFIX_TOOL
cd src
gmake -j2
xlc -G -o libhdf5.so H5.o H5checksum.o H5dbg.o H5lib_settings.o H5system.o H5timer.o H5trace.o H5[A-Z]*.o
cp -fp libhdf5.so $PREFIX_TOOL/lib
cd ../hl/src
make -j2
xlc -G -o libhdf5_hl.so H5*.o
cp -fp libhdf5_hl.so $PREFIX_TOOL/lib
