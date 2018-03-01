#!/bin/sh

SCRIPT_DIR=$(cd "$(dirname $0)"; pwd)
. $SCRIPT_DIR/../util.sh
. $SCRIPT_DIR/version.sh
set_prefix

. $PREFIX_TOOL/env.sh
LOG=$BUILD_DIR/espresso-$ESPRESSO_VERSION-$ESPRESSO_MA_REVISION.log
PREFIX="$PREFIX_APPS/espresso/espresso-$ESPRESSO_VERSION-$ESPRESSO_MA_REVISION"

if [ -d $PREFIX ]; then
  echo "Error: $PREFIX exists"
  exit 127
fi

sh $SCRIPT_DIR/setup.sh
rm -rf $LOG
start_info | tee -a $LOG
cd $BUILD_DIR/espresso-$ESPRESSO_VERSION
echo "[configure]" | tee -a $LOG
check ./configure --prefix=$PREFIX | tee -a $LOG
echo "[make]" | tee -a $LOG
check make pw pp | tee -a $LOG
echo "[make install]" | tee -a $LOG
check make install | tee -a $LOG
finish_info | tee -a $LOG

cat << EOF > $BUILD_DIR/espressovars.sh
# espresso $(basename $0 .sh) $ESPRESSO_VERSION $ESPRESSO_MA_REVISION $(date +%Y%m%d-%H%M%S)
test -z "\$MA_ROOT_TOOL" && . $PREFIX_TOOL/env.sh
export ESPRESSO_ROOT=$PREFIX
export ESPRESSO_VERSION=$ESPRESSO_VERSION
export ESPRESSO_MA_REVISION=$ESPRESSO_MA_REVISION
export PATH=\$ESPRESSO_ROOT/bin:\$PATH
export LD_LIBRARY_PATH=\$ESPRESSO_ROOT/lib:\$LD_LIBRARY_PATH
EOF
ESPRESSOVARS_SH=$PREFIX_APPS/espresso/espressovars-$ESPRESSO_VERSION-$ESPRESSO_MA_REVISION.sh
rm -f $ESPRESSOVARS_SH
cp -f $BUILD_DIR/espressovars.sh $ESPRESSOVARS_SH
rm -f $BUILD_DIR/espressovars.sh
cp -f $LOG $PREFIX_APPS/espresso/
