#!/bin/sh

SCRIPT_DIR=$(cd "$(dirname $0)"; pwd)
. $SCRIPT_DIR/../util.sh
. $SCRIPT_DIR/version.sh
set_prefix

. ${PREFIX_TOOL}/env.sh
LOG=${BUILD_DIR}/respack-${RESPACK_VERSION}-${RESPACK_MA_REVISION}.log

PREFIX="${PREFIX_APPS}/respack/respack-${RESPACK_VERSION}-${RESPACK_MA_REVISION}"

if [ -d $PREFIX ]; then
  echo "Error: $PREFIX exists"
  exit 127
fi

sh ${SCRIPT_DIR}/setup.sh
rm -rf $LOG
cd ${BUILD_DIR}/respack-${RESPACK_VERSION}
start_info | tee -a $LOG
echo "[make]" | tee -a $LOG
check rm -rf build
check mkdir build
check cd build
check cmake -DCMAKE_INSTALL_PREFIX=${PREFIX} -DCONFIG=gcc -DCMAKE_BUILD_TYPE=RELEASE ../
check make | tee -a $LOG
echo "[make install]" | tee -a $LOG
check make install | tee -a $LOG
echo "cp -r sample ${PREFIX}" | tee -a $LOG
cp -r ../sample ${PREFIX}
finish_info | tee -a $LOG

cat << EOF > ${BUILD_DIR}/respackvars.sh
# respack $(basename $0 .sh) ${RESPACK_VERSION} ${RESPACK_MA_REVISION} $(date +%Y%m%d-%H%M%S)
. ${PREFIX_TOOL}/env.sh
export RESPACK_ROOT=$PREFIX
export PATH=\${RESPACK_ROOT}/bin:\$PATH
EOF
RESPACKVARS_SH=${PREFIX_APPS}/respack/respackvars-${RESPACK_VERSION}-${RESPACK_MA_REVISION}.sh
rm -f $RESPACKVARS_SH
cp -f ${BUILD_DIR}/respackvars.sh $RESPACKVARS_SH
cp -f $LOG ${PREFIX_APPS}/respack/
