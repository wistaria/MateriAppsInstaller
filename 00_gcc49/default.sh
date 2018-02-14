#!/bin/sh

SCRIPT_DIR=$(cd "$(dirname $0)"; pwd)
. $SCRIPT_DIR/../util.sh
set_prefix
. $PREFIX_TOOL/env.sh
. $SCRIPT_DIR/version.sh

$SUDO_TOOL /bin/true
LOG=$BUILD_DIR/gcc49-$GCC49_VERSION-$GCC49_MA_REVISION.log
PREFIX=$PREFIX_TOOL/gcc49/gcc49-$GCC49_VERSION-$GCC49_MA_REVISION

if [ -d $PREFIX ]; then
  echo "Error: $PREFIX exists"
  exit 127
fi

sh $SCRIPT_DIR/setup.sh
rm -rf $LOG

rm -rf $BUILD_DIR/gcc49-$GCC49_VERSION-build
mkdir -p $BUILD_DIR/gcc49-$GCC49_VERSION-build
cd $BUILD_DIR/gcc49-$GCC49_VERSION-build
check $BUILD_DIR/gcc49-$GCC49_VERSION/configure --enable-languages=c,c++,fortran --prefix=$PREFIX --disable-multilib | tee $LOG
check make -j4 | tee -a $LOG
$SUDO_TOOL make install | tee -a $LOG
$SUDO_TOOL ln -s gcc49 $PREFIX/cc
$SUDO_TOOL ln -s gfortran $PREFIX/f95

cat << EOF > $BUILD_DIR/gcc49vars.sh
# gcc49 $(basename $0 .sh) $GCC49_VERSION $GCC49_MA_REVISION $(date +%Y%m%d-%H%M%S)
export GCC49_ROOT=$PREFIX
export GCC49_VERSION=$GCC49_VERSION
export GCC49_MA_REVISION=$GCC49_MA_REVISION
export PATH=\$GCC49_ROOT/bin:\$PATH
export LD_LIBRARY_PATH=\$GCC49_ROOT/lib64:\$LD_LIBRARY_PATH
EOF
GCC49VARS_SH=$PREFIX_TOOL/gcc49/gcc49vars-$GCC49_VERSION-$GCC49_MA_REVISION.sh
$SUDO_TOOL rm -f $GCC49VARS_SH
$SUDO_TOOL cp -f $BUILD_DIR/gcc49vars.sh $GCC49VARS_SH
rm -f $BUILD_DIR/gcc49vars.sh
$SUDO_TOOL cp -f $LOG $PREFIX_TOOL/gcc49/
