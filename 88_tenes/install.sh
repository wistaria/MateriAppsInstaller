#!/bin/sh

if [ $# -eq 0 ]; then
  mode=default
else
  mode=$1
fi

SCRIPT_DIR=$(cd "$(dirname $0)"; pwd)
CONFIG_DIR=$SCRIPT_DIR/config/$mode
if [ ! -d $CONFIG_DIR ]; then
  echo "Error: unknown mode: $mode"
  exit 127
fi

. $SCRIPT_DIR/../util.sh
. $SCRIPT_DIR/version.sh
set_prefix

. $PREFIX_TOOL/env.sh
LOG=$BUILD_DIR/tenes-$TENES_VERSION-$TENES_MA_REVISION.log
PREFIX="$PREFIX_APPS/tenes/tenes-$TENES_VERSION-$TENES_MA_REVISION"

if [ -d $PREFIX ]; then
  echo "Error: $PREFIX exists"
  exit 127
fi

sh $SCRIPT_DIR/setup.sh
rm -rf $LOG
cd $BUILD_DIR/TeNeS-$TENES_VERSION

start_info | tee -a $LOG
echo "[cmake]" | tee -a $LOG
rm -rf build && mkdir -p build && cd build
env LOG=$LOG PREFIX=$PREFIX CMAKE=${CMAKE:-cmake}\
  sh $CONFIG_DIR/cmake.sh

echo "[make]" | tee -a $LOG
make | tee -a $LOG

echo "[make install]" | tee -a $LOG
make install | tee -a $LOG
ln -sf $PREFIX/share/tenes/${TENES_VERSION}/sample $PREFIX/sample
cd ..

finish_info | tee -a $LOG

if [ -e $CONFIG_DIR/postprocess.sh ];then
  sh $CONFIG_DIR/postprocess.sh
fi

cat << EOF > $BUILD_DIR/tenesvars.sh
# tenes $(basename $0 .sh) $TENES_VERSION $TENES_MA_REVISION $(date +%Y%m%d-%H%M%S)
export TENES_ROOT=$PREFIX
export \$PATH=\$TENES_ROOT/bin:\$PATH
EOF
TENESVARS_SH=$PREFIX_APPS/tenes/tenesvars-$TENES_VERSION-$TENES_MA_REVISION.sh
rm -f $TENESVARS_SH
cp -f $BUILD_DIR/tenesvars.sh $TENESVARS_SH
cp -f $LOG $PREFIX_APPS/tenes
