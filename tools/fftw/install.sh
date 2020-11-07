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

. $SCRIPT_DIR/../../tools/cmake/find.sh; if [ ${MA_HAVE_CMAKE} = "no" ]; then echo "Error: cmake not found"; exit 127; fi

sh $SCRIPT_DIR/setup.sh

start_info | tee -a $LOG

echo "[configure double version]" | tee -a $LOG
check mkdir $BUILD_DIR/${__NAME__}-${__VERSION__}-${__MA_REVISION__}/build
cd $BUILD_DIR/${__NAME__}-${__VERSION__}-${__MA_REVISION__}/build
if [ -f $CONFIG_DIR/bootstrap.sh ]; then
  env SCRIPT_DIR=$SCRIPT_DIR PREFIX=$PREFIX LOG=$LOG sh $CONFIG_DIR/bootstrap.sh
else
  check cmake -DCMAKE_INSTALL_PREFIX=$PREFIX -DENABLE_OPENMP=ON .. 2>&1 | tee -a $LOG
fi
echo "[build]" | tee -a $LOG
check make 2>&1 | tee -a $LOG
echo "[make install]" | tee -a $LOG
make install 2>&1 | tee -a $LOG

echo "[configure float version]" | tee -a $LOG
check mkdir $BUILD_DIR/${__NAME__}-${__VERSION__}-${__MA_REVISION__}/build-float
cd $BUILD_DIR/${__NAME__}-${__VERSION__}-${__MA_REVISION__}/build-float
if [ -f $CONFIG_DIR/bootstrap-float.sh ]; then
  env SCRIPT_DIR=$SCRIPT_DIR PREFIX=$PREFIX LOG=$LOG sh $CONFIG_DIR/bootstrap-float.sh
else
  check cmake -DCMAKE_INSTALL_PREFIX=$PREFIX -DENABLE_OPENMP=ON -DENABLE_FLOAT=ON .. 2>&1 | tee -a $LOG
fi
echo "[build]" | tee -a $LOG
check make 2>&1 | tee -a $LOG
echo "[make install]" | tee -a $LOG
make install 2>&1 | tee -a $LOG

if [ -f $CONFIG_DIR/postprocess.sh ]; then
  env SCRIPT_DIR=$SCRIPT_DIR PREFIX=$PREFIX LOG=$LOG sh $CONFIG_DIR/postprocess.sh
fi

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
