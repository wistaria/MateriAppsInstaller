#!/bin/sh

SCRIPT_DIR=$(cd "$(dirname $0)"; pwd)
. $SCRIPT_DIR/../util.sh
. $SCRIPT_DIR/version.sh
set_prefix

. $PREFIX_TOOL/env.sh
CMAKE_VERSION_MAJOR=$(echo "$CMAKE_VERSION" | cut -d . -f 1,2)
PREFIX=$PREFIX_TOOL/cmake/cmake-$CMAKE_VERSION-$CMAKE_PATCH_VERSION
PREFIX_FRONTEND="$PREFIX/Linux-x86_64"
PREFIX_BACKEND="$PREFIX/Linux-s64fx"

cd $BUILD_DIR
rm -rf cmake-$CMAKE_VERSION cmake-$CMAKE_VERSION-Linux-x86_64 cmake-$CMAKE_VERSION-Linux-s64fx
if [ -f $HOME/source/cmake-$CMAKE_VERSION.tar.gz ]; then
  check tar zxf $HOME/source/cmake-$CMAKE_VERSION.tar.gz
else
  check wget -O - http://www.cmake.org/files/v$CMAKE_VERSION_MAJOR/cmake-$CMAKE_VERSION.tar.gz | tar zxf -
fi
if [ -f $SCRIPT_DIR/cmake-$CMAKE_VERSION.patch ]; then
  cd cmake-$CMAKE_VERSION
  check patch -p1 < $SCRIPT_DIR/cmake-$CMAKE_VERSION.patch
fi

cd $BUILD_DIR
check rm -rf cmake-$CMAKE_VERSION-Linux-x86_64
check mkdir -p cmake-$CMAKE_VERSION-Linux-x86_64
check cd cmake-$CMAKE_VERSION-Linux-x86_64
check $BUILD_DIR/cmake-$CMAKE_VERSION/bootstrap --prefix=$PREFIX_FRONTEND
check make -j4
$SUDO_TOOL make install

cd $BUILD_DIR
check rm -rf cmake-$CMAKE_VERSION-Linux-s64fx
check mkdir -p cmake-$CMAKE_VERSION-Linux-s64fx
check cd cmake-$CMAKE_VERSION-Linux-s64fx
CC="fccpx -Xg" CFLAGS="-O2 -DcmIML_ABI_NO_ERROR_LONG_LONG" CXX="FCCpx -Xg" CXXFLAGS="-O2 -DcmIML_ABI_NO_ERROR_LONG_LONG" check $PREFIX_FRONTEND/bin/cmake -DCMAKE_INSTALL_PREFIX=$PREFIX_BACKEND -DUPDATE_TYPE=svn -DHAVE_FCHDIR=1 -DHAVE_FCHMOD=1 -DHAVE_FCHOWN=1 -DHAVE_FCNTL=1 -DHAVE_UTIMES=1 -DHAVE_POSIX_STRERROR_R=1 $BUILD_DIR/cmake-$CMAKE_VERSION
CC="fccpx -Xg" CFLAGS="-O2 -DcmIML_ABI_NO_ERROR_LONG_LONG" CXX="FCCpx -Xg" CXXFLAGS="-O2 -DcmIML_ABI_NO_ERROR_LONG_LONG" check $PREFIX_FRONTEND/bin/cmake -DCMAKE_INSTALL_PREFIX=$PREFIX_BACKEND -DUPDATE_TYPE=svn -DHAVE_FCHDIR=1 -DHAVE_FCHMOD=1 -DHAVE_FCHOWN=1 -DHAVE_FCNTL=1 -DHAVE_UTIMES=1 -DHAVE_POSIX_STRERROR_R=1 $BUILD_DIR/cmake-$CMAKE_VERSION # run twice!
check make -j4
check $PREFIX_FRONTEND/bin/cmake -P cmake_install.cmake

cat << EOF > $BUILD_DIR/cmake
#!/bin/sh
OS=\$(uname -s)
ARCH=\$(uname -m)
COMMAND=\$(basename \$0)
PREFIX=$PREFIX
\$PREFIX/\$OS-\$ARCH/bin/\$COMMAND "\$@"
EOF
$SUDO_TOOL mkdir -p $PREFIX/bin
$SUDO_TOOL cp -f $BUILD_DIR/cmake $PREFIX/bin/cmake
$SUDO_TOOL cp -f $BUILD_DIR/cmake $PREFIX/bin/ctest
$SUDO_TOOL chmod +x $PREFIX/bin/cmake $PREFIX/bin/ctest

cat << EOF > $BUILD_DIR/cmakevars.sh
export CMAKE_ROOT=$PREFIX
export CMAKE_VERSION=$CMAKE_VERSION
export PATH=\$CMAKE_ROOT/bin:\$PATH
export CMAKE_PATH=\$CMAKE_ROOT/bin/cmake
export CTEST_PATH=\$CMAKE_ROOT/bin/ctest
EOF
CMAKEVARS_SH=$PREFIX_TOOL/cmake/cmakevars-$CMAKE_VERSION-$CMAKE_PATCH_VERSION.sh
$SUDO_TOOL rm -f $CMAKEVARS_SH
$SUDO_TOOL cp -f $BUILD_DIR/cmakevars.sh $CMAKEVARS_SH
