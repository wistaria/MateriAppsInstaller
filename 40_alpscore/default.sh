#!/bin/sh

SCRIPT_DIR=$(cd "$(dirname $0)"; pwd)
. $SCRIPT_DIR/../util.sh
. $SCRIPT_DIR/version.sh
set_prefix

. $PREFIX_TOOL/env.sh
LOG=$BUILD_DIR/alpscore-$ALPSCORE_VERSION-$ALPSCORE_PATCH_VERSION.log

PREFIX="$PREFIX_TOOL/alpscore/alpscore-$ALPSCORE_VERSION-$ALPSCORE_PATCH_VERSION"

if [ -d $PREFIX ]; then
  echo "Error: $PREFIX exists"
  exit 127
fi

sh $SCRIPT_DIR/setup.sh
mkdir -p $BUILD_DIR/alpscore-build-$ALPSCORE_VERSION
cd $BUILD_DIR/alpscore-build-$ALPSCORE_VERSION
start_info | tee -a $LOG
echo "[cmake]" | tee -a $LOG
check cmake -DCMAKE_INSTALL_PREFIX=$PREFIX \
  -DCMAKE_C_COMPILER=mpicc -DCMAKE_CXX_COMPILER=mpicxx \
  -DCMAKE_CXX_FLAGS="-DGTEST_HAS_TR1_TUPLE=0" \
  -DCMAKE_BUILD_TYPE=Release \
  $BUILD_DIR/alpscore-$ALPSCORE_VERSION | tee -a $LOG

echo "[make]" | tee -a $LOG
check make -j4 | tee -a $LOG
echo "[make install]" | tee -a $LOG
make install | tee -a $LOG
echo "[ctest]" | tee -a $LOG
ctest | tee -a $LOG
finish_info | tee -a $LOG

cat << EOF > $BUILD_DIR/alpscorevars.sh
# alpscore $(basename $0 .sh) $ALPSCORE_VERSION $ALPSCORE_MA_REVISION $(date +%Y%m%d-%H%M%S)
export ALPSCORE_ROOT=$PREFIX
export ALPSCore_DIR=$PREFIX
export LD_LIBRARY_PATH=\$ALPSCORE_ROOT/lib:\$LD_LIBRARY_PATH
EOF
ALPSCOREVARS_SH=$PREFIX_TOOL/alpscore/alpscorevars-$ALPSCORE_VERSION-$ALPSCORE_PATCH_VERSION.sh
rm -f $ALPSCOREVARS_SH
cp -f $BUILD_DIR/alpscorevars.sh $ALPSCOREVARS_SH
cp -f $LOG $PREFIX_TOOL/alpscore/
