#!/bin/sh

SCRIPT_DIR=$(cd "$(dirname $0)"; pwd)
. $SCRIPT_DIR/../util.sh
set_prefix
. $PREFIX_TOOL/env.sh
. $SCRIPT_DIR/version.sh

$SUDO_TOOL /bin/true
LOG=$BUILD_DIR/eigen3-$EIGEN3_VERSION-$EIGEN3_MA_REVISION.log
PREFIX=$PREFIX_TOOL/eigen3/eigen3-$EIGEN3_VERSION-$EIGEN3_MA_REVISION
PREFIX_FRONTEND="$PREFIX/Linux-x86_64"

if [ -d $PREFIX ]; then
  echo "Error: $PREFIX exists"
  exit 127
fi

sh $SCRIPT_DIR/setup.sh
rm -rf $LOG

mkdir $BUILD_DIR/eigen3-build-$EIGEN3_VERSION
cd $BUILD_DIR/eigen3-build-$EIGEN3_VERSION
start_info | tee -a $LOG
echo "[cmake]" | tee -a $LOG
check cmake -DCMAKE_INSTALL_PREFIX=$PREFIX \
  -DCMAKE_C_COMPILER=gcc -DCMAKE_CXX_COMPILER=g++ \
  $BUILD_DIR/eigen3-$EIGEN3_VERSION | tee -a $LOG

echo "[make]" | tee -a $LOG
check make -j4 | tee -a $LOG
echo "[make install]" | tee -a $LOG
$SUDO_TOOL make install | tee -a $LOG
#echo "[ctest]" | tee -a $LOG
#ctest | tee -a $LOG
finish_info | tee -a $LOG

cat << EOF > $BUILD_DIR/eigen3vars.sh
# eigen3 $(basename $0 .sh) $EIGEN3_VERSION $EIGEN3_MA_REVISION $(date +%Y%m%d-%H%M%S)
export EIGEN3_ROOT=$PREFIX
export Eigen3_DIR=$PREFIX
EOF
EIGEN3VARS_SH=$PREFIX_TOOL/eigen3/eigen3vars-$EIGEN3_VERSION-$EIGEN3_MA_REVISION.sh
$SUDO_TOOL rm -f $EIGEN3VARS_SH
$SUDO_TOOL cp -f $BUILD_DIR/eigen3vars.sh $EIGEN3VARS_SH
$SUDO_TOOL cp -f $LOG $PREFIX_TOOL/eigen3/
