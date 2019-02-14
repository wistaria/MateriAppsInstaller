#!/bin/sh

SCRIPT_DIR=$(cd "$(dirname $0)"; pwd)
. $SCRIPT_DIR/../util.sh
. $SCRIPT_DIR/version.sh
set_prefix

. $PREFIX_TOOL/env.sh
LOG=$BUILD_DIR/alpscore-cthyb-$ALPSCORE_CTHYB_VERSION-$ALPSCORE_CTHYB_MA_REVISION.log

source $PREFIX_APPS/triqs/triqsvars.sh

CXX=g++

PREFIX="$PREFIX_APPS/alpscore-cthyb/alpscore-cthyb-$ALPSCORE_CTHYB_VERSION-$ALPSCORE_CTHYB_MA_REVISION"

if [ -d $PREFIX ]; then
  echo "Error: $PREFIX exists"
  exit 127
fi

rm -f $LOG
sh $SCRIPT_DIR/setup.sh | tee -a $LOG

## ALPSCORE_CTHYB
rm -rf $BUILD_DIR/alpscore-cthyb-build-$ALPSCORE_CTHYB_VERSION
mkdir -p $BUILD_DIR/alpscore-cthyb-build-$ALPSCORE_CTHYB_VERSION
cd $BUILD_DIR/alpscore-cthyb-build-$ALPSCORE_CTHYB_VERSION
start_info | tee -a $LOG
echo "[cmake alpscore/CT-HYB]" | tee -a $LOG
check cmake \
  -DCMAKE_INSTALL_PREFIX=$PREFIX \
  -DCMAKE_BUILD_TYPE=RelWithDebInfo \
  -DCMAKE_CXX_COMPILER=$CXX \
  -DCMAKE_CXX_FLAGS="-std=c++1y" \
  $BUILD_DIR/alpscore-cthyb-$ALPSCORE_CTHYB_VERSION | tee -a $LOG
echo "[make alpscore/CT-HYB]" | tee -a $LOG
check make | tee -a $LOG
echo "[make install alpscore/CT-HYB]" | tee -a $LOG
make install | tee -a $LOG
echo "[ctest alpscore/CT-HYB]" | tee -a $LOG
ctest | tee -a $LOG

## alpscore-CTHYB-TRIQS-interface
export ALPSCoreCTHYB_DIR=$PREFIX
rm -rf $BUILD_DIR/alpscore-cthyb-triqs-interface-build-$ALPSCORE_CTHYB_TRIQS_INTERFACE_VERSION
mkdir -p $BUILD_DIR/alpscore-cthyb-triqs-interface-build-$ALPSCORE_CTHYB_TRIQS_INTERFACE_VERSION
cd $BUILD_DIR/alpscore-cthyb-triqs-interface-build-$ALPSCORE_CTHYB_TRIQS_INTERFACE_VERSION
start_info | tee -a $LOG
echo "[cmake alpscore/CT-HYB TRIQS interface]" | tee -a $LOG
check cmake \
  -DCMAKE_CXX_COMPILER=$CXX \
  -DCMAKE_CXX_FLAGS="-std=c++1y" \
  -DCMAKE_VERBOSE_MAKEFILE=ON \
  -DCMAKE_BUILD_TYPE=Release \
  -DTRIQS_PATH=$TRIQS_ROOT \
  $BUILD_DIR/alpscore-cthyb-triqs-interface-$ALPSCORE_CTHYB_TRIQS_INTERFACE_VERSION | tee -a $LOG
echo "[make alpscore/CT-HYB TRIQS interface]" | tee -a $LOG
check make | tee -a $LOG
echo "[make install alpscore/CT-HYb TRIQS interface]" | tee -a $LOG
make install | tee -a $LOG
echo "[ctest alpscore/CT-Hyb TRIQS interface]" | tee -a $LOG
ctest | tee -a $LOG

finish_info | tee -a $LOG

cat << EOF > $BUILD_DIR/alpscore-cthybvars.sh
# alpscore-cthyb $(basename $0 .sh) $ALPSCORE_CTHYB_VERSION $ALPSCORE_CTHYB_MA_REVISION $(date +%Y%m%d-%H%M%S)
. $PREFIX_TOOL/env.sh
export ALPSCORE_CTHYB_ROOT=$PREFIX
export PATH=\$ALPSCORE_CTHYB_ROOT/bin:\$PATH
EOF
ALPSCORE_CTHYBVARS_SH=$PREFIX_APPS/alpscore-cthyb/alpscore-cthybvars-$ALPSCORE_CTHYB_VERSION-$ALPSCORE_CTHYB_MA_REVISION.sh
rm -f $ALPSCORE_CTHYBVARS_SH
cp -f $BUILD_DIR/alpscore-cthybvars.sh $ALPSCORE_CTHYBVARS_SH
cp -f $LOG $PREFIX_APPS/alpscore-cthyb/
