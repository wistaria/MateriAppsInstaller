#!/bin/sh

SCRIPT_DIR=$(cd "$(dirname $0)"; pwd)
. $SCRIPT_DIR/../util.sh
set_prefix
. $PREFIX_TOOL/env.sh
. $SCRIPT_DIR/version.sh

$SUDO_TOOL /bin/true
LOG=$BUILD_DIR/gcc7-$GCC7_VERSION-$GCC7_MA_REVISION.log
PREFIX=$PREFIX_TOOL/gcc7/gcc7-$GCC7_VERSION-$GCC7_MA_REVISION

if [ -d $PREFIX ]; then
  echo "Error: $PREFIX exists"
  exit 127
fi

sh $SCRIPT_DIR/setup.sh
rm -rf $LOG

rm -rf $BUILD_DIR/gcc7-$GCC7_VERSION-build
mkdir -p $BUILD_DIR/gcc7-$GCC7_VERSION-build
cd $BUILD_DIR/gcc7-$GCC7_VERSION-build
check $BUILD_DIR/gcc7-$GCC7_VERSION/configure --enable-languages=c,c++,fortran --prefix=$PREFIX --disable-multilib | tee $LOG
check make -j4 | tee -a $LOG
$SUDO_TOOL make install | tee -a $LOG
$SUDO_TOOL ln -s gcc $PREFIX/bin/cc
$SUDO_TOOL ln -s gfortran $PREFIX/bin/f95

cat << EOF > $BUILD_DIR/gcc7vars.sh
# gcc7 $(basename $0 .sh) $GCC7_VERSION $GCC7_MA_REVISION $(date +%Y%m%d-%H%M%S)
export GCC7_ROOT=$PREFIX
export GCC7_VERSION=$GCC7_VERSION
export GCC7_MA_REVISION=$GCC7_MA_REVISION
export PATH=\$GCC7_ROOT/bin:\$PATH
export LD_LIBRARY_PATH=\$GCC7_ROOT/lib64:\$LD_LIBRARY_PATH
EOF
GCC7VARS_SH=$PREFIX_TOOL/gcc7/gcc7vars-$GCC7_VERSION-$GCC7_MA_REVISION.sh
$SUDO_TOOL rm -f $GCC7VARS_SH
$SUDO_TOOL cp -f $BUILD_DIR/gcc7vars.sh $GCC7VARS_SH
rm -f $BUILD_DIR/gcc7vars.sh
$SUDO_TOOL cp -f $LOG $PREFIX_TOOL/gcc7/
