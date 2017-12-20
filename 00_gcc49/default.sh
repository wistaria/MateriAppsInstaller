#!/bin/sh

SCRIPT_DIR=$(cd "$(dirname $0)"; pwd)
. $SCRIPT_DIR/../util.sh
set_prefix
. $PREFIX_TOOL/env.sh
. $SCRIPT_DIR/version.sh

$SUDO_TOOL /bin/true
LOG=$BUILD_DIR/gcc-$GCC_VERSION-$GCC_MA_REVISION.log
PREFIX=$PREFIX_TOOL/gcc/gcc-$GCC_VERSION-$GCC_MA_REVISION

if [ -d $PREFIX ]; then
  echo "Error: $PREFIX exists"
  exit 127
fi

sh $SCRIPT_DIR/setup.sh
rm -rf $LOG

rm -rf $BUILD_DIR/gcc-$GCC_VERSION-build
mkdir -p $BUILD_DIR/gcc-$GCC_VERSION-build
cd $BUILD_DIR/gcc-$GCC_VERSION-build
check $BUILD_DIR/gcc-$GCC_VERSION/configure --enable-languages=c,c++,fortran --prefix=$PREFIX --disable-multilib | tee $LOG
check make -j4 | tee -a $LOG
$SUDO_TOOL make install | tee -a $LOG
$SUDO_TOOL ln -s gcc $PREFIX/cc
$SUDO_TOOL ln -s gfortran $PREFIX/f95

cat << EOF > $BUILD_DIR/gccvars.sh
# gcc $(basename $0 .sh) $GCC_VERSION $GCC_MA_REVISION $(date +%Y%m%d-%H%M%S)
export GCC_ROOT=$PREFIX
export GCC_VERSION=$GCC_VERSION
export GCC_MA_REVISION=$GCC_MA_REVISION
export PATH=\$GCC_ROOT/bin:\$PATH
export LD_LIBRARY_PATH=\$GCC_ROOT/lib64:\$LD_LIBRARY_PATH
EOF
GCCVARS_SH=$PREFIX_TOOL/gcc/gccvars-$GCC_VERSION-$GCC_MA_REVISION.sh
$SUDO_TOOL rm -f $GCCVARS_SH
$SUDO_TOOL cp -f $BUILD_DIR/gccvars.sh $GCCVARS_SH
rm -f $BUILD_DIR/gccvars.sh
$SUDO_TOOL cp -f $LOG $PREFIX_TOOL/gcc/
