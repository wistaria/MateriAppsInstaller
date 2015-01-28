#!/bin/sh

SCRIPT_DIR=$(cd "$(dirname $0)"; pwd)
. $SCRIPT_DIR/../util.sh
. $SCRIPT_DIR/version.sh
set_prefix

. $PREFIX_TOOL/env.sh
LOG=$BUILD_DIR/modylas-$MODYLAS_VERSION-$MODYLAS_PATCH_VERSION.log

PREFIX="$PREFIX_APPS/modylas/modylas-$MODYLAS_VERSION-$MODYLAS_PATCH_VERSION"

if [ -d $PREFIX ]; then
  echo "Error: $PREFIX exists"
  exit 127
fi

sh $SCRIPT_DIR/download.sh
rm -rf $LOG
cd $BUILD_DIR/MODYLAS_$MODYLAS_VERSION/source
start_info | tee -a $LOG
echo "[make]" | tee -a $LOG
check ./configure --prefix=$PREFIX FC=mpif90 FCFLAGS="-O3 -fopenmp -cpp -DMPIPARA -DCOMM_CUBE -DFJMPIDIR -DSYNC_COM -DHALFDIRE -DONEPROC_AXIS -DSEGSHAKE" | tee -a $LOG
check make | tee -a $LOG
echo "[make install]" | tee -a $LOG
$SUDO_APPS make install | tee -a $LOG
cd $BUILD_DIR/MODYLAS_$MODYLAS_VERSION
$SUDO_APPS cp -r LICENSE.pdf document sample $PREFIX
finish_info | tee -a $LOG

cat << EOF > $BUILD_DIR/modylasvars.sh
. $PREFIX_TOOL/env.sh
export MODYLAS_ROOT=$PREFIX
export PATH=\$MODYLAS_ROOT/bin:\$PATH
EOF
MODYLASVARS_SH=$PREFIX_APPS/modylas/modylasvars-$MODYLAS_VERSION-$MODYLAS_PATCH_VERSION.sh
$SUDO_APPS rm -f $MODYLASVARS_SH
$SUDO_APPS cp -f $BUILD_DIR/modylasvars.sh $MODYLASVARS_SH
$SUDO_APPS cp -f $LOG $PREFIX_APPS/modylas
