#!/bin/sh
set -o pipefail

mode=${1:-default}
SCRIPT_DIR=$(cd "$(dirname $0)"; pwd)
CONFIG_DIR=$SCRIPT_DIR/config/$mode
if [ ! -d $CONFIG_DIR ]; then
  echo "Error: unknown mode: $mode"
  exit 127
fi

. $SCRIPT_DIR/../util.sh
. $SCRIPT_DIR/version.sh
set_prefix

. ${PREFIX_TOOL}/env.sh
LOG=${BUILD_DIR}/hphi-${HPHI_VERSION}-${HPHI_MA_REVISION}.log
PREFIX="${PREFIX_APPS}/hphi/hphi-${HPHI_VERSION}-${HPHI_MA_REVISION}"

if [ -d $PREFIX ]; then
  echo "Error: $PREFIX exists"
  exit 127
fi

sh ${SCRIPT_DIR}/setup.sh
rm -rf $LOG
cd ${BUILD_DIR}/hphi-${HPHI_VERSION}
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

cat << EOF > ${BUILD_DIR}/hphivars.sh
# hphi $(basename $0 .sh) ${HPHI_VERSION} ${HPHI_MA_REVISION} $(date +%Y%m%d-%H%M%S)
. ${PREFIX_TOOL}/env.sh
export HPHI_ROOT=$PREFIX
export PATH=\${HPHI_ROOT}/bin:\$PATH
EOF
HPHIVARS_SH=${PREFIX_APPS}/hphi/hphivars-${HPHI_VERSION}-${HPHI_MA_REVISION}.sh
rm -f $HPHIVARS_SH
cp -f ${BUILD_DIR}/hphivars.sh $HPHIVARS_SH
cp -f $LOG ${PREFIX_APPS}/hphi/
