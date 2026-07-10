#!/bin/sh
cat << EOF > config.txt
# configurable variables (e.g. compiler)

# use default if not defined
export MA_EXTRA_FLAGS="${MA_EXTRA_FLAGS:-}"
export MAKE_J="${MAKE_J:-"-j1"}"

# export explicitly if defined
test -n "${CXX+defined}" && export CXX="$CXX"
# KOKKOS GPU architecture for the "gpu" mode (e.g. AMPERE80, VOLTA70, HOPPER90)
test -n "${KOKKOS_ARCH+defined}" && export KOKKOS_ARCH="$KOKKOS_ARCH"

EOF
. ./config.txt

set -e

XTRACED=$(set -o | awk '/xtrace/{ print $2 }')
if [ "$XTRACED" = "on" ]; then
  SHFLAG="-x"
fi

mode=${1:-default}
SCRIPT_DIR=$(cd "$(dirname $0)"; pwd)
CONFIG_DIR=$SCRIPT_DIR/config/$mode
if [ ! -d $CONFIG_DIR ]; then
  echo "Error: unknown mode: $mode"
  echo "Available list:"
  ls -1 $SCRIPT_DIR/config
  exit 127
fi
DEFAULT_CONFIG_DIR=$SCRIPT_DIR/config/default

# Fail fast (before the download/extract) when the gpu mode is selected without
# its required KOKKOS_ARCH, so the user does not wait for setup only to hit the
# guard in config/gpu/preprocess.sh.
if [ "$mode" = "gpu" ] && [ -z "${KOKKOS_ARCH:-}" ]; then
  echo "Error: KOKKOS_ARCH is not set (required for the gpu mode)."
  echo "Set it to your GPU Kokkos arch, e.g. AMPERE80 (A100), VOLTA70 (V100), HOPPER90 (H100)."
  exit 1
fi

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
echo "mode = $mode" | tee -a $LOG

rm -rf ${BUILD_DIR}/${__NAME__}-${__VERSION__}
pipefail check sh $SHFLAG ${SCRIPT_DIR}/setup.sh \| tee -a $LOG
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

cat << EOF > ${BUILD_DIR}/${__NAME__}vars.sh
# ${__NAME__} $(basename $0 .sh) ${__VERSION__} ${__MA_REVISION__} $(date +%Y%m%d-%H%M%S)
. ${MA_ROOT}/env.sh
export ${ROOTNAME}=$PREFIX
export PATH=\${${ROOTNAME}}/bin:\$PATH
export LD_LIBRARY_PATH=\${${ROOTNAME}}/lib64:\${${ROOTNAME}}/lib:\$LD_LIBRARY_PATH
EOF
VARS_SH=${MA_ROOT}/${__NAME__}/${__NAME__}vars-${__VERSION__}-${__MA_REVISION__}.sh
rm -f $VARS_SH
cp -f ${BUILD_DIR}/${__NAME__}vars.sh $VARS_SH
cp -f $LOG ${MA_ROOT}/${__NAME__}/
