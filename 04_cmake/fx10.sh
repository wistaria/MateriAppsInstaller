#!/bin/sh

SCRIPT_DIR=$(cd "$(dirname $0)"; pwd)
. $SCRIPT_DIR/../util.sh
set_prefix
. $PREFIX_TOOL/env.sh
. $SCRIPT_DIR/version.sh
. $SCRIPT_DIR/version.sh

LOG=$BUILD_DIR/cmake-$CMAKE_VERSION-$CMAKE_MA_REVISION.log
PREFIX=$PREFIX_TOOL/cmake/cmake-$CMAKE_VERSION-$CMAKE_MA_REVISION
PREFIX_FRONTEND="$PREFIX/Linux-x86_64"
PREFIX_BACKEND="$PREFIX/Linux-s64fx"

if [ -d $PREFIX ]; then
  echo "Error: $PREFIX exists"
  exit 127
fi

sh $SCRIPT_DIR/setup.sh
rm -rf $LOG

cd $BUILD_DIR
check mkdir -p cmake-$CMAKE_VERSION-Linux-x86_64
check cd cmake-$CMAKE_VERSION-Linux-x86_64
echo "[make Linux-x86_64]" | tee -a $LOG
check $BUILD_DIR/cmake-$CMAKE_VERSION/bootstrap --prefix=$PREFIX_FRONTEND | tee -a $LOG
check make -j4 | tee -a $LOG
echo "[make instsall Linux-x86_64]" | tee -a $LOG
make install | tee -a $LOG

cd $BUILD_DIR
check mkdir -p cmake-$CMAKE_VERSION-Linux-s64fx
check cd cmake-$CMAKE_VERSION-Linux-s64fx
echo "[make Linux-s64fx]" | tee -a $LOG
CC="fccpx -Xg" CFLAGS="-O2 -DcmIML_ABI_NO_ERROR_LONG_LONG" CXX="FCCpx -Xg" CXXFLAGS="-O2 -DcmIML_ABI_NO_ERROR_LONG_LONG" check $PREFIX_FRONTEND/bin/cmake -DCMAKE_INSTALL_PREFIX=$PREFIX_BACKEND -DUPDATE_TYPE=svn -DHAVE_FCHDIR=1 -DHAVE_FCHMOD=1 -DHAVE_FCHOWN=1 -DHAVE_FCNTL=1 -DHAVE_UTIMES=1 -DHAVE_POSIX_STRERROR_R=1 $BUILD_DIR/cmake-$CMAKE_VERSION | tee -a $LOG
CC="fccpx -Xg" CFLAGS="-O2 -DcmIML_ABI_NO_ERROR_LONG_LONG" CXX="FCCpx -Xg" CXXFLAGS="-O2 -DcmIML_ABI_NO_ERROR_LONG_LONG" check $PREFIX_FRONTEND/bin/cmake -DCMAKE_INSTALL_PREFIX=$PREFIX_BACKEND -DUPDATE_TYPE=svn -DHAVE_FCHDIR=1 -DHAVE_FCHMOD=1 -DHAVE_FCHOWN=1 -DHAVE_FCNTL=1 -DHAVE_UTIMES=1 -DHAVE_POSIX_STRERROR_R=1 $BUILD_DIR/cmake-$CMAKE_VERSION | tee -a $LOG # run twice!
check make -j4 | tee -a $LOG
echo "[make install Linux-s64fx]" | tee -a $LOG
check $PREFIX_FRONTEND/bin/cmake -P cmake_install.cmake | tee -a $LOG

cat << EOF > $BUILD_DIR/cmake
#!/bin/sh
OS=\$(uname -s)
ARCH=\$(uname -m)
COMMAND=\$(basename \$0)
PREFIX=$PREFIX
\$PREFIX/\$OS-\$ARCH/bin/\$COMMAND "\$@"
EOF
mkdir -p $PREFIX/bin
cp -f $BUILD_DIR/cmake $PREFIX/bin/cmake
cp -f $BUILD_DIR/cmake $PREFIX/bin/ctest
chmod +x $PREFIX/bin/cmake $PREFIX/bin/ctest

cat << EOF > $BUILD_DIR/cmakevars.sh
# cmake $(basename $0 .sh) $CMAKE_VERSION $CMAKE_MA_REVISION $(date +%Y%m%d-%H%M%S)
export CMAKE_ROOT=$PREFIX
export CMAKE_VERSION=$CMAKE_VERSION
export CMAKE_MA_REVISION=$CMAKE_MA_REVISION
export PATH=\$CMAKE_ROOT/bin:\$PATH
export CMAKE_PATH=\$CMAKE_ROOT/bin/cmake
export CTEST_PATH=\$CMAKE_ROOT/bin/ctest
EOF
CMAKEVARS_SH=$PREFIX_TOOL/cmake/cmakevars-$CMAKE_VERSION-$CMAKE_MA_REVISION.sh
rm -f $CMAKEVARS_SH
cp -f $BUILD_DIR/cmakevars.sh $CMAKEVARS_SH
rm -f $BUILD_DIR/cmakevars.sh
cp -f $LOG $PREFIX_TOOL/cmake/
