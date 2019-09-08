SCRIPT_DIR=$(cd "$(dirname $0)"; pwd)
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
echo "[make]" | tee -a $LOG
check rm -rf build
check mkdir build
check cd build
check cmake -DCMAKE_INSTALL_PREFIX=${PREFIX} -DCONFIG=intel ../
check make | tee -a $LOG
echo "[make install]" | tee -a $LOG
check make install | tee -a $LOG
echo "cp -r ../samples ${PREFIX}" | tee -a $LOG
cp -r ../samples ${PREFIX}
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
