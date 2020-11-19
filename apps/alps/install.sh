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

. ${MA_ROOT}/env.sh
export LOG=${BUILD_DIR}/${__NAME__}-${__VERSION__}-${__MA_REVISION__}.log
export PREFIX="${MA_ROOT}/${__NAME__}/${__NAME__}-${__VERSION__}-${__MA_REVISION__}"

if [ -d $PREFIX ]; then
  echo "Error: $PREFIX exists"
  exit 127
fi

. $SCRIPT_DIR/../../tools/boost/find.sh; if [ ${MA_HAVE_BOOST} = "no" ]; then echo "Error: boost not found"; exit 127; fi
. $SCRIPT_DIR/../../tools/cmake/find.sh; if [ ${MA_HAVE_CMAKE} = "no" ]; then echo "Error: cmake not found"; exit 127; fi
. $SCRIPT_DIR/../../tools/hdf5/find.sh; if [ ${MA_HAVE_HDF5} = "no" ]; then echo "Error: hdf5 not found"; exit 127; fi

sh ${SCRIPT_DIR}/setup.sh
rm -rf $LOG
cd ${BUILD_DIR}/${__NAME__}-${__VERSION__}
start_info | tee -a $LOG

echo "[preprocess]" | tee -a $LOG
if [ -f CMakeLists.txt ]; then
  rm -rf build && mkdir -p build && cd build
fi
if [ -e $CONFIG_DIR/preprocess.sh ];then
  env SCRIPT_DIR=$SCRIPT_DIR PREFIX=$PREFIX LOG=$LOG sh $CONFIG_DIR/preprocess.sh
else
  env SCRIPT_DIR=$SCRIPT_DIR PREFIX=$PREFIX LOG=$LOG sh $SCRIPT_DIR/config/default/preprocess.sh
fi

echo "[make]" | tee -a $LOG
check make VERBOSE=1 2>&1 | tee -a $LOG || exit 1
echo "[make install]" | tee -a $LOG
check make install 2>&1 | tee -a $LOG || exit 1
echo "[make check]" | tee -a $LOG
make test 2>&1 | tee -a $LOG

if [ -e $CONFIG_DIR/postprocess.sh ];then
  check sh $CONFIG_DIR/postprocess.sh
fi

finish_info | tee -a $LOG

ROOTNAME=$(toupper ${__NAME__})_ROOT

cat << EOF > ${BUILD_DIR}/${__NAME__}vars.sh
# ${__NAME__} $(basename $0 .sh) ${__VERSION__} ${__MA_REVISION__} $(date +%Y%m%d-%H%M%S)
. ${MA_ROOT}/env.sh
export ${ROOTNAME}=$PREFIX
export PATH=\${${ROOTNAME}}/bin:\$PATH
export LD_LIBRARY_PATH=\${${ROOTNAME}}/lib:\$LD_LIBRARY_PATH
export PYTHONPATH=\${${ROOTNAME}}/lib:\$PYTHONPATH
EOF
VARS_SH=${MA_ROOT}/${__NAME__}/${__NAME__}vars-${__VERSION__}-${__MA_REVISION__}.sh
rm -f $VARS_SH
cp -f ${BUILD_DIR}/${__NAME__}vars.sh $VARS_SH
cp -f $LOG ${MA_ROOT}/${__NAME__}/
