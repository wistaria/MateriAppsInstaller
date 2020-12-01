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

set +e
. $SCRIPT_DIR/../../tools/openblas/find.sh; if [ ${MA_HAVE_BLAS} = "no" ]; then echo "Error: blas not found"; exit 127; fi
set -e

sh $SCRIPT_DIR/setup.sh

start_info | tee -a $LOG

echo "[cmake]" | tee -a $LOG
mkdir -p $BUILD_DIR/lapack-$LAPACK_VERSION/build
cd $BUILD_DIR/lapack-$LAPACK_VERSION/build
cmake -DCMAKE_INSTALL_PREFIX=$PREFIX -DBUILD_SHARED_LIBS=ON -DBUILD_TESTING=ON -DUSE_OPTIMIZED_BLAS=ON -DCBLAS=ON -DLAPACKE=ON .. 2>&1 | tee -a ${LOG}
echo "[make]" | tee -a $LOG
check make 2>&1 | tee -a $LOG
echo "[make test]" | tee -a $LOG
check make test 2>&1 | tee -a $LOG
echo "[make install]" | tee -a $LOG
check make install 2>&1 | tee -a $LOG

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
