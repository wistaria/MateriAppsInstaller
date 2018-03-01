#!/bin/sh

SCRIPT_DIR=$(cd "$(dirname $0)"; pwd)
. $SCRIPT_DIR/../util.sh
. $SCRIPT_DIR/version.sh
set_prefix

. $PREFIX_TOOL/env.sh
LOG=$BUILD_DIR/qe-$QE_VERSION-$QE_MA_REVISION.log
PREFIX="$PREFIX_APPS/qe/qe-$QE_VERSION-$QE_MA_REVISION"

if [ -d $PREFIX ]; then
  echo "Error: $PREFIX exists"
  exit 127
fi

sh $SCRIPT_DIR/setup.sh
rm -rf $LOG
start_info | tee -a $LOG
cd $BUILD_DIR/qe-$QE_VERSION
echo "[configure]" | tee -a $LOG
check ./configure --prefix=$PREFIX | tee -a $LOG
echo "[make]" | tee -a $LOG
check make pw pp | tee -a $LOG
echo "[make install]" | tee -a $LOG
check make install | tee -a $LOG
finish_info | tee -a $LOG

cat << EOF > $BUILD_DIR/qevars.sh
# qe $(basename $0 .sh) $QE_VERSION $QE_MA_REVISION $(date +%Y%m%d-%H%M%S)
test -z "\$MA_ROOT_TOOL" && . $PREFIX_TOOL/env.sh
export QE_ROOT=$PREFIX
export QE_VERSION=$QE_VERSION
export QE_MA_REVISION=$QE_MA_REVISION
export PATH=\$QE_ROOT/bin:\$PATH
export LD_LIBRARY_PATH=\$QE_ROOT/lib:\$LD_LIBRARY_PATH
EOF
QEVARS_SH=$PREFIX_APPS/qe/qevars-$QE_VERSION-$QE_MA_REVISION.sh
rm -f $QEVARS_SH
cp -f $BUILD_DIR/qevars.sh $QEVARS_SH
rm -f $BUILD_DIR/qevars.sh
cp -f $LOG $PREFIX_APPS/qe/
