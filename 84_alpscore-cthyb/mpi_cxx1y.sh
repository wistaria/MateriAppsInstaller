#!/bin/sh

SCRIPT_DIR=$(cd "$(dirname $0)"; pwd)
. $SCRIPT_DIR/../util.sh
. $SCRIPT_DIR/version.sh
set_prefix

. $PREFIX_TOOL/env-cxx1y.sh
LOG=$BUILD_DIR/alpscore-cthyb-$ALPSCORE_CTHYB_VERSION-$ALPSCORE_CTHYB_MA_REVISION.log

source $PREFIX_APPS/triqs/triqsvars.sh

CXX=mpicxx

PREFIX="$PREFIX_APPS/alpscore-cthyb/alpscore-cthyb-$ALPSCORE_CTHYB_VERSION-$ALPSCORE_CTHYB_MA_REVISION"
PREFIX_CXX03="$PREFIX/cxx03"
PREFIX_CXX1Y="$PREFIX/cxx1y"

if [ -d $PREFIX ]; then
  echo "Error: $PREFIX exists"
  exit 127
fi

rm -f $LOG
sh $SCRIPT_DIR/setup.sh | tee -a $LOG

## ALPSCORE_CTHYB
rm -rf $BUILD_DIR/alpscore-cthyb-build-$ALPSCORE_CTHYB_VERSION-cxx1y
mkdir -p $BUILD_DIR/alpscore-cthyb-build-$ALPSCORE_CTHYB_VERSION-cxx1y
cd $BUILD_DIR/alpscore-cthyb-build-$ALPSCORE_CTHYB_VERSION-cxx1y
start_info | tee -a $LOG
echo "[cmake alpscore/CT-HYB]" | tee -a $LOG
check cmake \
  -DCMAKE_INSTALL_PREFIX=$PREFIX_CXX1Y \
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
export ALPSCoreCTHYB_DIR=$PREFIX_CXX1Y
rm -rf $BUILD_DIR/alpscore-cthyb-triqs-interface-build-$ALPSCORE_CTHYB_TRIQS_INTERFACE_VERSION-cxx1y
mkdir -p $BUILD_DIR/alpscore-cthyb-triqs-interface-build-$ALPSCORE_CTHYB_TRIQS_INTERFACE_VERSION-cxx1y
cd $BUILD_DIR/alpscore-cthyb-triqs-interface-build-$ALPSCORE_CTHYB_TRIQS_INTERFACE_VERSION-cxx1y
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
unset ALPSCORE_CTHYB_ROOT
if [ "\$MA_CXX_STANDARD" = "cxx1y" ]; then
  export ALPSCORE_CTHYB_ROOT=$PREFIX_CXX1Y
  export PATH=\$ALPSCORE_CTHYB_ROOT/bin:\$PATH
else
  echo "Error: alpscore-cthyb is compiled only with cxx1y support"
fi
EOF
ALPSCORE_CTHYBVARS_SH=$PREFIX_APPS/alpscore-cthyb/alpscore-cthybvars-$ALPSCORE_CTHYB_VERSION-$ALPSCORE_CTHYB_MA_REVISION.sh
rm -f $ALPSCORE_CTHYBVARS_SH
cp -f $BUILD_DIR/alpscore-cthybvars.sh $ALPSCORE_CTHYBVARS_SH
cp -f $LOG $PREFIX_APPS/alpscore-cthyb/
