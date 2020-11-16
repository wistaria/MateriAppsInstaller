#!/bin/sh

set -o pipefail

mode=${1:-default}
SCRIPT_DIR=$(cd "$(dirname $0)"; pwd)
CONFIG_DIR=$SCRIPT_DIR/config/$mode
if [ ! -d $CONFIG_DIR ]; then
  echo "Error: unknown mode: $mode"
  echo "Available list:"
  ls -1 $SCRIPT_DIR/config
  exit 127
fi

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

start_info | tee -a $LOG

cd $BUILD_DIR/${__NAME__}-${__VERSION__}-${__MA_REVISION__}
if [ -f $CONFIG_DIR/preprocess.sh ]; then
  env SCRIPT_DIR=$SCRIPT_DIR PREFIX=$PREFIX LOG=$LOG sh $CONFIG_DIR/preprocess.sh
fi

echo "[build]" | tee -a $LOG
check make PREFIX=$PREFIX NO_CBLAS=1 NO_LAPACK=1 NO_AFFINITY=1 NO_WARMUP=1 DYNAMIC_ARCH=1 NUM_THREADS=64 2>&1 | tee -a $LOG
echo "[make install]" | tee -a $LOG
make -i install PREFIX=$PREFIX NO_CBLAS=1 NO_LAPACK=1 NO_LAPACKE=1 2>&1 | tee -a $LOG

if [ -f $CONFIG_DIR/postprocess.sh ]; then
  env SCRIPT_DIR=$SCRIPT_DIR PREFIX=$PREFIX LOG=$LOG sh $CONFIG_DIR/postprocess.sh
fi

finish_info | tee -a $LOG

ROOTNAME=$(toupper ${__NAME__})_ROOT

cat << EOF > ${BUILD_DIR}/${__NAME__}vars.sh
# ${__NAME__} $(basename $0 .sh) ${__VERSION__} ${__MA_REVISION__} $(date +%Y%m%d-%H%M%S)
export ${ROOTNAME}=$PREFIX
export LD_LIBRARY_PATH=\${${ROOTNAME}}/lib:\$LD_LIBRARY_PATH
EOF
VARS_SH=${MA_ROOT}/${__NAME__}/${__NAME__}vars-${__VERSION__}-${__MA_REVISION__}.sh
rm -f $VARS_SH
cp -f ${BUILD_DIR}/${__NAME__}vars.sh $VARS_SH
cp -f $LOG ${MA_ROOT}/${__NAME__}/
