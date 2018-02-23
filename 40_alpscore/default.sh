#!/bin/sh

SCRIPT_DIR=$(cd "$(dirname $0)"; pwd)
. $SCRIPT_DIR/../util.sh
. $SCRIPT_DIR/version.sh
set_prefix

. $PREFIX_TOOL/env.sh
LOG=$BUILD_DIR/alpscore-$ALPSCORE_VERSION-$ALPSCORE_MA_REVISION.log

PREFIX="$PREFIX_TOOL/alpscore/alpscore-$ALPSCORE_VERSION-$ALPSCORE_MA_REVISION"
PREFIX_CXX03="$PREFIX/cxx03"

if [ -d $PREFIX ]; then
  echo "Error: $PREFIX exists"
  exit 127
fi

sh $SCRIPT_DIR/setup.sh

mkdir -p $BUILD_DIR/alpscore-build-$ALPSCORE_VERSION-cxx03
cd $BUILD_DIR/alpscore-build-$ALPSCORE_VERSION-cxx03
start_info | tee -a $LOG
echo "[cmake cxx03]" | tee -a $LOG
check cmake -DCMAKE_INSTALL_PREFIX=$PREFIX_CXX03 \
  -DCMAKE_C_COMPILER=gcc -DCMAKE_CXX_COMPILER=g++ \
  -DCMAKE_CXX_FLAGS="-DGTEST_HAS_TR1_TUPLE=0" \
  $BUILD_DIR/alpscore-$ALPSCORE_VERSION | tee -a $LOG
echo "[make cxx03]" | tee -a $LOG
check make -j4 | tee -a $LOG
echo "[make install cxx03]" | tee -a $LOG
make install | tee -a $LOG
echo "[ctest cxx03]" | tee -a $LOG
ctest | tee -a $LOG
finish_info | tee -a $LOG

cat << EOF > $BUILD_DIR/alpscorevars.sh
# alpscore $(basename $0 .sh) $ALPSCORE_VERSION $ALPSCORE_MA_REVISION $(date +%Y%m%d-%H%M%S)
if [ "\$MA_CXX_STANDARD" = "cxx1y" ]; then
  echo "Warning: alpscore is installed without cxx1y support"
else
  export ALPSCORE_ROOT=$PREFIX_CXX03
  export ALPSCore_DIR=\$ALPSCORE_ROOT
  export LD_LIBRARY_PATH=\$ALPSCORE_ROOT/lib:\$LD_LIBRARY_PATH
fi
EOF
ALPSCOREVARS_SH=$PREFIX_TOOL/alpscore/alpscorevars-$ALPSCORE_VERSION-$ALPSCORE_MA_REVISION.sh
rm -f $ALPSCOREVARS_SH
cp -f $BUILD_DIR/alpscorevars.sh $ALPSCOREVARS_SH
cp -f $LOG $PREFIX_TOOL/alpscore/
