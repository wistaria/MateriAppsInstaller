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

. ${MA_ROOT}/env.sh
LOG=${BUILD_DIR}/${__NAME__}-${__VERSION__}-${__MA_REVISION__}.log
PREFIX="${MA_ROOT}/${__NAME__}/${__NAME__}-${__VERSION__}-${__MA_REVISION__}"

if [ -d $PREFIX ]; then
  echo "Error: $PREFIX exists"
  exit 127
fi

sh ${SCRIPT_DIR}/setup.sh
rm -rf $LOG
cd ${BUILD_DIR}/${__NAME__}-${__VERSION__}
start_info | tee -a $LOG

echo "[cmake]" | tee -a $LOG
rm -rf build && mkdir -p build && cd build
check env LOG=$LOG PREFIX=$PREFIX CMAKE=${CMAKE:-cmake}\
  sh $CONFIG_DIR/cmake.sh

echo "[make]" | tee -a $LOG
check make | tee -a $LOG || exit 1
echo "[make install]" | tee -a $LOG
check make install | tee -a $LOG || exit 1
echo "cp -r samples ${PREFIX}" | tee -a $LOG
cp -r ../samples ${PREFIX}

if [ -e $CONFIG_DIR/postprocess.sh ];then
  env PREFIX=$PREFIX sh $CONFIG_DIR/postprocess.sh
fi

finish_info | tee -a $LOG

cat << EOF > ${BUILD_DIR}/${__NAME__}vars.sh
# ${__NAME__} $(basename $0 .sh) ${__VERSION__} ${__MA_REVISION__} $(date +%Y%m%d-%H%M%S)
. ${MA_ROOT}/env.sh
export HPHI_ROOT=$PREFIX
export PATH=\${HPHI_ROOT}/bin:\$PATH
EOF
HPHIVARS_SH=${MA_ROOT}/${__NAME__}/${__NAME__}vars-${__VERSION__}-${__MA_REVISION__}.sh
rm -f $HPHIVARS_SH
cp -f ${BUILD_DIR}/${__NAME__}vars.sh $HPHIVARS_SH
cp -f $LOG ${MA_ROOT}/${__NAME__}/
