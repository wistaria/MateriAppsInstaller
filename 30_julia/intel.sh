#!/bin/sh

SCRIPT_DIR=$(cd "$(dirname $0)"; pwd)
. $SCRIPT_DIR/../util.sh
set_prefix
. $PREFIX_TOOL/env.sh
. $SCRIPT_DIR/version.sh

LOG=$BUILD_DIR/julia-$JULIA_VERSION-$JULIA_MA_REVISION.log
PREFIX=$PREFIX_TOOL/julia/julia-$JULIA_VERSION-$JULIA_MA_REVISION

if [ -d $PREFIX ]; then
  echo "Error: $PREFIX exists"
  exit 127
fi

sh $SCRIPT_DIR/setup.sh
rm -rf $LOG

start_info | tee -a $LOG

cd $BUILD_DIR/julia-$JULIA_VERSION
echo "[make]" | tee -a $LOG
cat << EOF > Make.user
USEICC=1
USEIFC=1
USE_INTEL_MKL=1
USE_INTEL_MKL_FFT=1
USE_INTEL_MKL_LIBM=1
prefix=$PREFIX
EOF
check make | tee -a $LOG
make install | tee -a $LOG

finish_info | tee -a $LOG

cat << EOF > $BUILD_DIR/juliavars.sh
# julia $(basename $0 .sh) $JULIA_VERSION $JULIA_MA_REVISION $(date +%Y%m%d-%H%M%S)
export JULIA_ROOT=$PREFIX
export PATH=\$JULIA_ROOT/bin:\$PATH
EOF
JULIAVARS_SH=$PREFIX_TOOL/julia/juliavars-$JULIA_VERSION-$JULIA_MA_REVISION.sh
rm -f $JULIAVARS_SH
cp -f $BUILD_DIR/juliavars.sh $JULIAVARS_SH
rm -f $BUILD_DIR/juliavars.sh
cp -f $LOG $PREFIX_TOOL/julia/
