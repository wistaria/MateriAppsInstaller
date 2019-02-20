#!/bin/sh

SCRIPT_DIR=$(cd "$(dirname $0)"; pwd)
. $SCRIPT_DIR/../util.sh
. $SCRIPT_DIR/version.sh
set_prefix

. $PREFIX_TOOL/env.sh
LOG=$BUILD_DIR/fftw-$FFTW_VERSION-$FFTW_MA_REVISION.log
rm -rf $LOG

PREFIX=$PREFIX_TOOL/fftw/fftw-$FFTW_VERSION-$FFTW_MA_REVISION

if [ -d $PREFIX ]; then
  echo "Error: $PREFIX exists"
  exit 127
fi

sh $SCRIPT_DIR/setup.sh

cd $BUILD_DIR/fftw-$FFTW_VERSION
echo "[make]" | tee -a $LOG
check ./configure CC=$(which icc) F77=$(which ifort) --prefix=$PREFIX -enable-shared --enable-threads --enable-avx | tee -a $LOG
check make -j4 | tee -a $LOG
echo "[make install]" | tee -a $LOG
make install | tee -a $LOG
check make clean | tee -a $LOG
echo "[make float version]" | tee -a $LOG
check ./configure CC=$(which icc) F77=$(which ifort) --prefix=$PREFIX -enable-shared --enable-threads --enable-avx --enable-float | tee -a $LOG
check make -j4 | tee -a $LOG
echo "[make install]" | tee -a $LOG
make install | tee -a $LOG

cat << EOF > $BUILD_DIR/fftwvars.sh
# fftw $(basename $0 .sh) $FFTW_VERSION $FFTW_MA_REVISION $(date +%Y%m%d-%H%M%S)
export FFTW_ROOT=$PREFIX
export FFTW_VERSION=$FFTW_VERSION
export FFTW_MA_REVISION=$FFTW_MA_REVISION
export PATH=\$FFTW_ROOT/bin:\$PATH
export LD_LIBRARY_PATH=\$FFTW_ROOT/lib:\$LD_LIBRARY_PATH
EOF
FFTWVARS_SH=$PREFIX_TOOL/fftw/fftwvars-$FFTW_VERSION-$FFTW_MA_REVISION.sh
rm -f $FFTWVARS_SH
cp -f $BUILD_DIR/fftwvars.sh $FFTWVARS_SH
rm -f $BUILD_DIR/fftwvars.sh
cp -f $LOG $PREFIX_TOOL/fftw/
