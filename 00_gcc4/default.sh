#!/bin/sh

SCRIPT_DIR=$(cd "$(dirname $0)"; pwd)
. $SCRIPT_DIR/../util.sh
set_prefix
. $PREFIX_TOOL/env.sh
. $SCRIPT_DIR/version.sh

$SUDO_TOOL /bin/true
LOG=$BUILD_DIR/gcc4-$GCC4_VERSION-$GCC4_MA_REVISION.log
PREFIX=$PREFIX_TOOL/gcc4/gcc4-$GCC4_VERSION-$GCC4_MA_REVISION

if [ -d $PREFIX ]; then
  echo "Error: $PREFIX exists"
  exit 127
fi

sh $SCRIPT_DIR/setup.sh
rm -rf $LOG

rm -rf $BUILD_DIR/gcc4-$GCC4_VERSION-build
mkdir -p $BUILD_DIR/gcc4-$GCC4_VERSION-build
cd $BUILD_DIR/gcc4-$GCC4_VERSION-build
check $BUILD_DIR/gcc4-$GCC4_VERSION/configure --enable-languages=c,c++,fortran --prefix=$PREFIX --disable-multilib | tee $LOG
check make -j4 | tee -a $LOG
$SUDO_TOOL make install | tee -a $LOG
$SUDO_TOOL ln -s gcc $PREFIX/bin/cc
$SUDO_TOOL ln -s gfortran $PREFIX/bin/f95

cat << EOF > $BUILD_DIR/gcc4vars.sh
# gcc4 $(basename $0 .sh) $GCC4_VERSION $GCC4_MA_REVISION $(date +%Y%m%d-%H%M%S)
export GCC4_ROOT=$PREFIX
export GCC4_VERSION=$GCC4_VERSION
export GCC4_MA_REVISION=$GCC4_MA_REVISION
export PATH=\$GCC4_ROOT/bin:\$PATH
export LD_LIBRARY_PATH=\$GCC4_ROOT/lib64:\$LD_LIBRARY_PATH
EOF
GCC4VARS_SH=$PREFIX_TOOL/gcc4/gcc4vars-$GCC4_VERSION-$GCC4_MA_REVISION.sh
$SUDO_TOOL rm -f $GCC4VARS_SH
$SUDO_TOOL cp -f $BUILD_DIR/gcc4vars.sh $GCC4VARS_SH
rm -f $BUILD_DIR/gcc4vars.sh
$SUDO_TOOL cp -f $LOG $PREFIX_TOOL/gcc4/
