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

. $PREFIX_TOOL/env.sh
LOG=$BUILD_DIR/mvmc-$MVMC_VERSION-$MVMC_MA_REVISION.log
PREFIX="$PREFIX_APPS/mvmc/mvmc-$MVMC_VERSION-$MVMC_MA_REVISION"

if [ -d $PREFIX ]; then
  echo "Error: $PREFIX exists"
  exit 127
fi

sh $SCRIPT_DIR/setup.sh
rm -rf $LOG
cd $BUILD_DIR/mvmc-$MVMC_VERSION
start_info | tee -a $LOG

echo "[cmake]" | tee -a $LOG
rm -rf build && mkdir -p build && cd build
check env LOG=$LOG PREFIX=$PREFIX CMAKE=${CMAKE:-cmake}\
  sh $CONFIG_DIR/cmake.sh

echo "[make]" | tee -a $LOG
check make | tee -a $LOG || exit 1
echo "[make install]" | tee -a $LOG
check make install | tee -a $LOG || exit 1
echo "cp -r ../samples ${PREFIX}" | tee -a $LOG
cp -r ../samples ${PREFIX}

if [ -e $CONFIG_DIR/postprocess.sh ];then
  env PREFIX=$PREFIX sh $CONFIG_DIR/postprocess.sh
fi

finish_info | tee -a $LOG

cat << EOF > ${BUILD_DIR}/mvmcvars.sh
# mvmc $(basename $0 .sh) ${MVMC_VERSION} ${MVMC_MA_REVISION} $(date +%Y%m%d-%H%M%S)
. ${PREFIX_TOOL}/env.sh
export MVMC_ROOT=$PREFIX
export PATH=\${MVMC_ROOT}/bin:\$PATH
EOF
MVMCVARS_SH=${PREFIX_APPS}/mvmc/mvmcvars-${MVMC_VERSION}-${MVMC_MA_REVISION}.sh
rm -f $MVMCVARS_SH
cp -f ${BUILD_DIR}/mvmcvars.sh $MVMCVARS_SH
cp -f $LOG ${PREFIX_APPS}/mvmc/
