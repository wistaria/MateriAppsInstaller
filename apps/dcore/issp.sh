#!/bin/sh

SCRIPT_DIR=$(cd "$(dirname $0)"; pwd)
. $SCRIPT_DIR/../util.sh
. $SCRIPT_DIR/version.sh
set_prefix

. $PREFIX_TOOL/env.sh
LOG=$BUILD_DIR/dcore-$DCORE_VERSION-$DCORE_MA_REVISION.log
rm -f $LOG

PREFIX="${PREFIX_APPS}/dcore/dcore-${DCORE_VERSION}-${DCORE_MA_REVISION}"

CXX=icpc

TRIQSVARS=${PREFIX_APPS}/triqs/triqsvars.sh
source $TRIQSVARS

if [ -f $PREFIX ]; then
  echo "Error: $PREFIX exists"
  exit 127
fi

sh $SCRIPT_DIR/setup.sh | tee -a $LOG

rm -rf $BUILD_DIR/dcore-build-$DCORE_VERSION
mkdir -p $BUILD_DIR/dcore-build-$DCORE_VERSION
cd $BUILD_DIR/dcore-build-$DCORE_VERSION
start_info | tee -a $LOG
echo "[cmake]" | tee -a $LOG
check cmake \
  -DCMAKE_INSTALL_PREFIX=$PREFIX \
  -DTRIQS_PATH=$TRIQS_ROOT \
  -DMPIEXEC=mpijob \
  $BUILD_DIR/dcore-$DCORE_VERSION | tee -a $LOG
echo "[make]" | tee -a $LOG
check make -j4 | tee -a $LOG
echo "[make install]" | tee -a $LOG
make install | tee -a $LOG
echo "[copy examples]" | tee -a $LOG
cp -r $BUILD_DIR/dcore-$DCORE_VERSION/examples $PREFIX/

finish_info | tee -a $LOG

cp ${PREFIX}/bin/dcore ${PREFIX}/bin/dcore_nocount
cat << EOF > ${PREFIX}/bin/dcore
/home/issp/materiapps/tool/bin/issp-ucount dcore
${PREFIX}/bin/dcore_nocount \$@
EOF
chmod +x ${PREFIX}/bin/dcore

cat << EOF > ${BUILD_DIR}/dcorevars.sh
# dcore $(basename $0 .sh) ${DCORE_VERSION} ${DCORE_MA_REVISION} $(date +%Y%m%d-%H%M%S)
. ${PREFIX_TOOL}/env.sh
. $TRIQSVARS
export DCORE_ROOT=$PREFIX
export PATH=\${DCORE_ROOT}/bin:\$PATH
EOF
DCOREVARS_SH=${PREFIX_APPS}/dcore/dcorevars-${DCORE_VERSION}-${DCORE_MA_REVISION}.sh
rm -f $DCOREVARS_SH
cp -f ${BUILD_DIR}/dcorevars.sh $DCOREVARS_SH
cp -f $LOG ${PREFIX_APPS}/dcore/
