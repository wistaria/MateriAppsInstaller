#!/bin/sh
set -e

XTRACED=$(set -o | awk '/xtrace/{ print $2 }')
echo configurations > config.txt
eval "
set -x

# configurable variables (e.g. compiler)
export CC=${CC:-}
export MAKE_J=${MAKE_J:-}
export OPENSSL_ROOT=${OPENSSL_ROOT:-}
export MKLROOT=${MKLROOT:-}

" 2> config.txt
if [ "$XTRACED" = "off" ]; then
  set +x
  SHFLAG=""
else
  SHFLAG="-x"
fi

mode=${1:-default}
export SCRIPT_DIR=$(cd "$(dirname $0)"; pwd)
CONFIG_DIR=$SCRIPT_DIR/config/$mode
if [ ! -d $CONFIG_DIR ]; then
  echo "Error: unknown mode: $mode"
  echo "Available list:"
  ls -1 $SCRIPT_DIR/config
  exit 127
fi
DEFAULT_CONFIG_DIR=$SCRIPT_DIR/config/default

export UTIL_SH=$SCRIPT_DIR/../../scripts/util.sh
. $UTIL_SH
. $SCRIPT_DIR/version.sh
set_prefix

. ${MA_ROOT}/env.sh
export PREFIX="${MA_ROOT}/${__NAME__}/${__NAME__}-${__VERSION__}-${__MA_REVISION__}"
if [ -d $PREFIX ]; then
  echo "Error: $PREFIX exists"
  exit 127
fi
export LOG=${BUILD_DIR}/${__NAME__}-${__VERSION__}-${__MA_REVISION__}.log
mv config.txt $LOG

set +e
. $SCRIPT_DIR/../../tools/libffi/find.sh; if [ ${MA_HAVE_LIBFFI} = "no" ]; then echo "Error: libffi not found"; exit 127; fi
. $SCRIPT_DIR/../../tools/openssl/find.sh; if [ ${MA_HAVE_OPENSSL} = "no" ]; then echo "Error: openssl not found"; exit 127; fi
. $SCRIPT_DIR/../../tools/tcltk/find.sh; if [ ${MA_HAVE_TCLTK} = "no" ]; then echo "Error: tcltk not found"; exit 127; fi
set -e

rm -rf ${BUILD_DIR}/${__NAME__}-${__VERSION__}
pipefail sh $SHFLAG ${SCRIPT_DIR}/setup.sh \| tee -a $LOG
cd ${BUILD_DIR}/${__NAME__}-${__VERSION__}
start_info | tee -a $LOG

for process in preprocess build install postprocess; do
  if [ -f $CONFIG_DIR/${process}.sh ]; then
    echo "[${process}]" | tee -a $LOG
    pipefail check sh $SHFLAG $CONFIG_DIR/${process}.sh \| tee -a $LOG
  elif [ -f $DEFAULT_CONFIG_DIR/${process}.sh ]; then
    echo "[${process}]" | tee -a $LOG
    pipefail check sh $SHFLAG $DEFAULT_CONFIG_DIR/${process}.sh \| tee -a $LOG
  fi
done

finish_info | tee -a $LOG

ROOTNAME=$(toupper ${__NAME__})_ROOT

MAJOR_VERSION=$(echo $__VERSION__ | cut -d'.' -f1)
MINOR_VERSION=$(echo $__VERSION__ | cut -d'.' -f2)

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
