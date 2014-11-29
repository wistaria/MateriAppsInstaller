#!/bin/sh

SCRIPT_DIR=$(cd "$(dirname $0)"; pwd)
. $SCRIPT_DIR/../util.sh
. $SCRIPT_DIR/version.sh
set_prefix

. $PREFIX_TOOL/env.sh
CMAKE_VERSION_MAJOR=$(echo "$CMAKE_VERSION" | cut -d . -f 1,2)
PREFIX=$PREFIX_TOOL/cmake/cmake-$CMAKE_VERSION

cd $BUILD_DIR
rm -rf cmake-$CMAKE_VERSION
if [ -f $HOME/source/cmake-$CMAKE_VERSION.tar.gz ]; then
  check tar zxf $HOME/source/cmake-$CMAKE_VERSION.tar.gz
else
  check wget -O - http://www.cmake.org/files/v$CMAKE_VERSION_MAJOR/cmake-$CMAKE_VERSION.tar.gz | tar zxf -
fi
cd cmake-$CMAKE_VERSION
check ./bootstrap --prefix=$PREFIX
check gmake -j4
$SUDO_TOOL gmake install

cat << EOF > $BUILD_DIR/cmakevars.sh
export PATH=$PREFIX/bin:\$PATH
export LD_LIBRARY_PATH=$PREFIX/lib:\$LD_LIBRARY_PATH
EOF
CMAKEVARS_SH=$PREFIX_TOOL/cmake/cmakevars-$CMAKE_VERSION.sh
$SUDO_TOOL rm -f $CMAKEVARS_SH
$SUDO_TOOL cp -f $BUILD_DIR/cmakevars.sh $CMAKEVARS_SH
