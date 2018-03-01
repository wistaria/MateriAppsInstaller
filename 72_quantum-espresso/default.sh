#!/bin/sh

SCRIPT_DIR=$(cd "$(dirname $0)"; pwd)
. $SCRIPT_DIR/../util.sh
. $SCRIPT_DIR/version.sh
set_prefix

. $PREFIX_TOOL/env.sh
LOG=$BUILD_DIR/quantum-espresso-$QUANTUM_ESPRESSO_VERSION-$QUANTUM_ESPRESSO_MA_REVISION.log
PREFIX="$PREFIX_APPS/quantum-espresso/quantum-espresso-$QUANTUM_ESPRESSO_VERSION-$QUANTUM_ESPRESSO_MA_REVISION"

if [ -d $PREFIX ]; then
  echo "Error: $PREFIX exists"
  exit 127
fi

sh $SCRIPT_DIR/setup.sh
rm -rf $LOG
start_info | tee -a $LOG
cd $BUILD_DIR/quantum-espresso-$QUANTUM_ESPRESSO_VERSION
echo "[configure]" | tee -a $LOG
check ./configure --prefix=$PREFIX | tee -a $LOG
echo "[make]" | tee -a $LOG
check make pw pp | tee -a $LOG
echo "[make install]" | tee -a $LOG
check make install | tee -a $LOG
finish_info | tee -a $LOG

cat << EOF > $BUILD_DIR/quantum-espressovars.sh
# quantum-espresso $(basename $0 .sh) $QUANTUM_ESPRESSO_VERSION $QUANTUM_ESPRESSO_MA_REVISION $(date +%Y%m%d-%H%M%S)
test -z "\$MA_ROOT_TOOL" && . $PREFIX_TOOL/env.sh
export QUANTUM_ESPRESSO_ROOT=$PREFIX
export QUANTUM_ESPRESSO_VERSION=$QUANTUM_ESPRESSO_VERSION
export QUANTUM_ESPRESSO_MA_REVISION=$QUANTUM_ESPRESSO_MA_REVISION
export PATH=\$QUANTUM_ESPRESSO_ROOT/bin:\$PATH
export LD_LIBRARY_PATH=\$QUANTUM_ESPRESSO_ROOT/lib:\$LD_LIBRARY_PATH
EOF
QUANTUM_ESPRESSOVARS_SH=$PREFIX_APPS/quantum-espresso/quantum-espressovars-$QUANTUM_ESPRESSO_VERSION-$QUANTUM_ESPRESSO_MA_REVISION.sh
rm -f $QUANTUM_ESPRESSOVARS_SH
cp -f $BUILD_DIR/quantum-espressovars.sh $QUANTUM_ESPRESSOVARS_SH
rm -f $BUILD_DIR/quantum-espressovars.sh
cp -f $LOG $PREFIX_APPS/quantum-espresso/
