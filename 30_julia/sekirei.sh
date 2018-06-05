#!/bin/sh

SCRIPT_DIR=$(cd "$(dirname $0)"; pwd)
. $SCRIPT_DIR/../util.sh
set_prefix
. $PREFIX_TOOL/env.sh
. $SCRIPT_DIR/version.sh

. /etc/profile.d/modules.sh
module unload cmake
module load cmake/3.10.2

LOG=$BUILD_DIR/julia-$JULIA_VERSION-$JULIA_MA_REVISION.log
PREFIX=$PREFIX_TOOL/julia/julia-$JULIA_VERSION-$JULIA_MA_REVISION

if [ -d $PREFIX ]; then
  echo "Error: $PREFIX exists"
  exit 127
fi

JULIA_MAJOR_VERSION=$(echo $JULIA_VERSION | cut -d. -f1,2)

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
MARCH=haswell
CERTFILE=/etc/mft/ca-bundle.crt
prefix=$PREFIX
EOF
check env GOMAXPROCS=1 make | tee -a $LOG
make install | tee -a $LOG

# cd $PREFIX/share/julia/site/v$JULIA_MAJOR_VERSION/
# echo "[MPI.jl]" | tee -a $LOG
# check git clone https://github.com/JuliaParallel/MPI.jl | tee -a $LOG
# cd MPI.jl
# check git checkout $MPIJL_VERSION | tee -a $LOG
# cd deps
# check $PREFIX/bin/julia build.jl | tee -a $LOG

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
