#!/bin/sh

SCRIPT_DIR=$(cd "$(dirname $0)"; pwd)
. ${SCRIPT_DIR}/../../scripts/util.sh
. ${SCRIPT_DIR}/version.sh
set_prefix

. ${MA_ROOT}/env.sh

VARS_SH=${MA_ROOT}/${__NAME__}/${__NAME__}vars-${__VERSION__}-${__MA_REVISION__}.sh
if [ -f ${VARS_SH} ]; then
  rm -f ${MA_ROOT}/env.d/${__NAME__}vars.sh
  ln -s ${VARS_SH} ${MA_ROOT}/env.d/${__NAME__}vars.sh
else
  echo "Error: ${VARS_SH} not found"
  exit 127
fi
