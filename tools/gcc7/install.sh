#!/bin/sh
set -o pipefail

# mode=${1:-default}
SCRIPT_DIR=$(cd "$(dirname $0)"; pwd)
# CONFIG_DIR=$SCRIPT_DIR/config/$mode
# if [ ! -d $CONFIG_liDIR ]; then
#   echo "Error: unknown mode: $mode"
#   exit 127
# fi

. $SCRIPT_DIR/../../scripts/util.sh
. $SCRIPT_DIR/version.sh
set_prefix

. $MA_ROOT/env.sh
LOG=$BUILD_DIR/${__NAME__}-${__VERSION__}-${__MA_REVISION__}.log
PREFIX=$MA_ROOT/${__NAME__}/${__NAME__}-${__VERSION__}-${__MA_REVISION__}

if [ -d $PREFIX ]; then
  echo "Error: $PREFIX exists"
  exit 127
fi

sh $SCRIPT_DIR/setup.sh

cd ${BUILD_DIR}/${__NAME__}-${__VERSION__}-${__MA_REVISION__}
start_info | tee -a $LOG

echo "[configure]" | tee -a $LOG
rm -rf build && mkdir -p build && cd build
check $BUILD_DIR/${__NAME__}-${__VERSION__}-${__MA_REVISION__}/configure --enable-languages=c,c++,fortran --prefix=$PREFIX --disable-multilib | tee -a $LOG

echo "[make]" | tee -a $LOG
check make | tee -a $LOG

echo "[install]" | tee -a $LOG
check make install | tee -a $LOG
ln -s gcc $PREFIX/bin/cc
ln -s gfortran $PREFIX/bin/f95

finish_info | tee -a $LOG

ROOTNAME=$(toupper ${__NAME__})_ROOT

cat << EOF > ${BUILD_DIR}/${__NAME__}vars.sh
# ${__NAME__} $(basename $0 .sh) ${__VERSION__} ${__MA_REVISION__} $(date +%Y%m%d-%H%M%S)
export ${ROOTNAME}=$PREFIX
export PATH=\${${ROOTNAME}}/bin:\$PATH
export LD_LIBRARY_PATH=\${${ROOTNAME}}/lib:\$LD_LIBRARY_PATH
EOF
VARS_SH=${MA_ROOT}/${__NAME__}/${__NAME__}vars-${__VERSION__}-${__MA_REVISION__}.sh
rm -f $VARS_SH
cp -f ${BUILD_DIR}/${__NAME__}vars.sh $VARS_SH
cp -f $LOG ${MA_ROOT}/${__NAME__}/
