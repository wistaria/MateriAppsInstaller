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

. $SCRIPT_DIR/../../tools/openssl/find.sh; if [ ${MA_HAVE_OPENSSL} = "no" ]; then echo "Error: openssl not found"; exit 127; fi

sh $SCRIPT_DIR/setup.sh
rm -f $LOG
check cd $BUILD_DIR/${__NAME__}-${__VERSION__}-${__MA_REVISION__}
start_info | tee -a $LOG

echo "[preprocess]" | tee -a $LOG
rm -rf build && mkdir -p build && cd build
if [ -f $CONFIG_DIR/preprocess.sh ]; then
  env SCRIPT_DIR=$SCRIPT_DIR PREFIX=$PREFIX LOG=$LOG sh $CONFIG_DIR/preprocess.sh
else
  check ../bootstrap --prefix=$PREFIX 2>&1 | tee -a $LOG
fi

echo "[make]" | tee -a $LOG
check make 2>&1 | tee -a $LOG
echo "[make install]" | tee -a $LOG
check make install 2>&1 | tee -a $LOG

if [ -f $CONFIG_DIR/postprocess.sh ];then
  check sh $CONFIG_DIR/postprocess.sh
fi

finish_info | tee -a $LOG

ROOTNAME=$(toupper ${__NAME__})_ROOT

cat << EOF > ${BUILD_DIR}/${__NAME__}vars.sh
# ${__NAME__} $(basename $0 .sh) ${__VERSION__} ${__MA_REVISION__} $(date +%Y%m%d-%H%M%S)
export ${ROOTNAME}=$PREFIX
export PATH=\${${ROOTNAME}}/bin:\$PATH
EOF
VARS_SH=${MA_ROOT}/${__NAME__}/${__NAME__}vars-${__VERSION__}-${__MA_REVISION__}.sh
rm -f $VARS_SH
cp -f ${BUILD_DIR}/${__NAME__}vars.sh $VARS_SH
cp -f $LOG ${MA_ROOT}/${__NAME__}/
