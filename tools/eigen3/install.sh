#!/bin/sh
set -o pipefail

mode=${1:-default}
SCRIPT_DIR=$(cd "$(dirname $0)"; pwd)
CONFIG_DIR=$SCRIPT_DIR/config/$mode
if [ ! -d $CONFIG_DIR ]; then
  echo "Error: unknown mode: $mode"
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

mkdir $BUILD_DIR/${__NAME__}-${__VERSION__}/build
cd $BUILD_DIR/${__NAME__}-${__VERSION__}/build
echo "[cmake]" | tee -a $LOG
check cmake -DCMAKE_INSTALL_PREFIX=$PREFIX -DBUILD_TESTING=OFF \
  $BUILD_DIR/${__NAME__}-${__VERSION__} 2>&1 | tee -a $LOG
echo "[make install]" | tee -a $LOG
make install 2>&1 | tee -a $LOG

finish_info | tee -a $LOG

ROOTNAME=$(toupper ${__NAME__})_ROOT
DIRNAME=$(capitalize ${__NAME__})_DIR
cat << EOF > ${BUILD_DIR}/${__NAME__}vars.sh
# ${__NAME__} $(basename $0 .sh) ${__VERSION__} ${__MA_REVISION__} $(date +%Y%m%d-%H%M%S)
export ${ROOTNAME}=$PREFIX
export ${DIRNAME}=\${${ROOTNAME}}
EOF
VARS_SH=${MA_ROOT}/${__NAME__}/${__NAME__}vars-${__VERSION__}-${__MA_REVISION__}.sh
rm -f $VARS_SH
cp -f ${BUILD_DIR}/${__NAME__}vars.sh $VARS_SH
cp -f $LOG ${MA_ROOT}/${__NAME__}/
