#!/bin/sh

SCRIPT_DIR=$(cd "$(dirname $0)"; pwd)
. $SCRIPT_DIR/../util.sh
. $SCRIPT_DIR/version.sh
set_prefix

. $PREFIX_TOOL/env.sh
LOG=$BUILD_DIR/komega-$KOMEGA_VERSION-$KOMEGA_MA_REVISION.log

PREFIX="$PREFIX_TOOL/komega/komega-$KOMEGA_VERSION-$KOMEGA_MA_REVISION"

if [ -d $PREFIX ]; then
  echo "Error: $PREFIX exists"
  exit 127
fi

sh $SCRIPT_DIR/setup.sh
rm -rf $LOG
cd $BUILD_DIR/komega-$KOMEGA_VERSION
start_info | tee -a $LOG
echo "[configure]" | tee -a $LOG
./configure --prefix=$PREFIX --with-mpi CC=icc F77=ifort | tee -a $LOG
echo "[make install]" | tee -a $LOG
check make install | tee -a $LOG

finish_info | tee -a $LOG

cat << EOF > $BUILD_DIR/komegavars.sh
# komega $(basename $0.sh) $KOMEGA_VERSION $KOMEGA_MA_REVISION $(date +%Y%m%d-%H%M%S)
export KOMEGA_ROOT=$PREFIX
export KOMEGA_VERSION=$KOMEGA_VERSION
export KOMEGA_MA_REVISION=$KOMEGA_MA_REVISION
export PATH=\$KOMEGA_ROOT/bin:\$PATH
export LD_LIBRARY_PATH=\$KOMEGA_ROOT/lib:\$LD_LIBRARY_PATH
EOF
KOMEGAVARS_SH=$PREFIX_TOOL/komega/komegavars-$KOMEGA_VERSION-$KOMEGA_MA_REVISION.sh
rm -f $KOMEGAVARS_SH
cp -f $BUILD_DIR/komegavars.sh $KOMEGAVARS_SH
cp -f $LOG $PREFIX_TOOL/komega
