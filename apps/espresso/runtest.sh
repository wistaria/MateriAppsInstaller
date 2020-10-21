#!/bin/sh
set -o pipefail

# configurable variables (e.g. compiler)
export OMP_NUM_THREADS=${OMP_NUM_THREADS:-1}
export MPIEXEC=${MPIEXEC-"mpiexec"}
export MPIEXEC_NPROCS_OPT=${MPIEXEC_NPROCS_OPT-"-np"}

if [ -z "$MPIEXEC" ];then
  export MPIEXEC_CMD=""
else
  export MPIEXEC_CMD="${MPIEXEC} ${MPIEXEC_NPROCS_OPT} 1"
fi

mode=${1:-default}
SCRIPT_DIR=$(cd "$(dirname $0)"; pwd)

. $SCRIPT_DIR/../../scripts/util.sh
. $SCRIPT_DIR/version.sh
set_prefix

trap 'finish_test $?' EXIT

. ${MA_ROOT}/env.sh

VARS_SH=${MA_ROOT}/${__NAME__}/${__NAME__}vars-${__VERSION__}-${__MA_REVISION__}.sh
if [ ! -f "$VARS_SH" ]; then
  echo "Error: configuration file (${VARS_SH}) does not exist"
  exit 127
fi
echo "source $VARS_SH"
. $VARS_SH

ROOTNAME=$(toupper ${__NAME__})_ROOT
eval PREFIX='$'$ROOTNAME
if [ -z "$PREFIX" ]; then
  echo "Error: $ROOTNAME does not set in the configuration file (${VARS_SH})"
  exit 127
fi
if [ ! -d "$PREFIX" ]; then
  echo "Error: $PREFIX does not exist"
  exit 127
fi

export PREFIX

sh test/download_pp.sh

workdir="test_`date +%FT%T`"
rm -rf $workdir
cp -r test $workdir
cd $workdir
sh ./test.sh || exit 127

echo
echo "Test finishes ($workdir)"
