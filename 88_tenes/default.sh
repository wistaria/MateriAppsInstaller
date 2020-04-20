#!/bin/sh

SCRIPT_DIR=$(cd "$(dirname $0)"; pwd)
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
cd $BUILD_DIR/TeNeS-v$TENES_VERSION
start_info | tee -a $LOG
echo "[cmake]" | tee -a $LOG
echo "mkdir build && cd build" | tee -a $LOG
mkdir build && cd build
cmake \
  -DCMAKE_INSTALL_PREFIX=$PREFIX \
  ../ | tee -a $LOG

echo "[make]" | tee -a $LOG
make | tee -a $LOG

echo "[make install]" | tee -a $LOG
make install | tee -a $LOG
cd ..

finish_info | tee -a $LOG

cat << EOF > $BUILD_DIR/tenesvars.sh
# tenes $(basename $0 .sh) $TENES_VERSION $TENES_MA_REVISION $(date +%Y%m%d-%H%M%S)
export TENES_ROOT=$PREFIX
export \$PATH=\$TENES_ROOT/bin:\$PATH
EOF
TENESVARS_SH=$PREFIX_APPS/tenes/tenesvars-$TENES_VERSION-$TENES_MA_REVISION.sh
rm -f $TENESVARS_SH
cp -f $BUILD_DIR/tenesvars.sh $TENESVARS_SH
cp -f $LOG $PREFIX_APPS/tenes
