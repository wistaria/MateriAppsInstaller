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

echo "[bootstrap]" | tee -a $LOG
check cd ${BUILD_DIR}/${__NAME__}-${__VERSION__}-${__MA_REVISION__}/tools/build
if [ -f $CONFIG_DIR/bootstrap.sh ]; then
  env SCRIPT_DIR=$SCRIPT_DIR PREFIX=$PREFIX LOG=$LOG sh $CONFIG_DIR/bootstrap.sh
else  
  env SCRIPT_DIR=$SCRIPT_DIR PREFIX=$PREFIX LOG=$LOG sh $SCRIPT_DIR/config/default/bootstrap.sh
fi

echo "[build]" | tee -a $LOG
check cd $BUILD_DIR/${__NAME__}-${__VERSION__}-${__MA_REVISION__}
if [ -f $CONFIG_DIR/build.sh ]; then
  env SCRIPT_DIR=$SCRIPT_DIR PREFIX=$PREFIX LOG=$LOG sh $CONFIG_DIR/build.sh
else
  env SCRIPT_DIR=$SCRIPT_DIR PREFIX=$PREFIX LOG=$LOG sh $SCRIPT_DIR/config/default/build.sh
fi

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
export PYTHONPATH=\${${ROOTNAME}}/lib/python:\$PYTHONPATH
EOF
VARS_SH=${MA_ROOT}/${__NAME__}/${__NAME__}vars-${__VERSION__}-${__MA_REVISION__}.sh
rm -f $VARS_SH
cp -f ${BUILD_DIR}/${__NAME__}vars.sh $VARS_SH
cp -f $LOG ${MA_ROOT}/${__NAME__}/
