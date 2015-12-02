#!/bin/sh

SCRIPT_DIR=$(cd "$(dirname $0)"; pwd)
. $SCRIPT_DIR/../util.sh
. $SCRIPT_DIR/version.sh
set_prefix

$SUDO_APPS true
. $PREFIX_TOOL/env.sh
LOG=$BUILD_DIR/feram-$FERAM_VERSION-$FERAM_MA_REVISION.log
PREFIX="$PREFIX_APPS/feram/feram-$FERAM_VERSION-$FERAM_MA_REVISION"

if [ -d $PREFIX ]; then
  echo "Error: $PREFIX exists"
  exit 127
fi

sh $SCRIPT_DIR/setup.sh
rm -rf $LOG
cd $BUILD_DIR/feram-$FERAM_VERSION
start_info | tee -a $LOG
echo "[make]" | tee -a $LOG
if [ -n "$FFTW_ROOT" ]; then
  check ./configure --prefix=$PREFIX FC=ifort --with-fft=fftw3_threads --with-lapack=mkl CPPFLAGS="-I$FFTW_ROOT/include" LDFLAGS="-L$FFTW_ROOT/lib" | tee -a $LOG
else
  check ./configure --prefix=$PREFIX FC=ifort --with-fft=fftw3_threads --with-lapack=mkl | tee -a $LOG
fi
check make | tee -a $LOG
echo "[make install]" | tee -a $LOG
$SUDO_APPS make install | tee -a $LOG
$SUDO_APPS mkdir -p $PREFIX/share/feram/example
$SUDO_APPS cp -rp src/[0-9]* $PREFIX/share/feram/example
finish_info | tee -a $LOG

cat << EOF > $BUILD_DIR/feramvars.sh
# feram $(basename $0 .sh) $FERAM_VERSION $FERAM_MA_REVISION $(date +%Y%m%d-%H%M%S)
. $PREFIX_TOOL/env.sh
export FERAM_ROOT=$PREFIX
export FERAM_VERSION=$FERAM_VERSION
export FERAM_MA_REVISION=$FERAM_MA_REVISION
export PATH=\$FERAM_ROOT/bin:\$PATH
EOF
FERAMVARS_SH=$PREFIX_APPS/feram/feramvars-$FERAM_VERSION-$FERAM_MA_REVISION.sh
$SUDO_APPS rm -f $FERAMVARS_SH
$SUDO_APPS cp -f $BUILD_DIR/feramvars.sh $FERAMVARS_SH
rm -f $BUILD_DIR/feramvars.sh
$SUDO_APPS cp -f $LOG $PREFIX_APPS/feram/
