#!/bin/sh

SCRIPT_DIR=$(cd "$(dirname $0)"; pwd)
. $SCRIPT_DIR/../util.sh
. $SCRIPT_DIR/version.sh
set_prefix

. $PREFIX_TOOL/env.sh
LOG=$BUILD_DIR/lammps-$LAMMPS_VERSION-$LAMMPS_MA_REVISION.log
PREFIX="$PREFIX_APPS/lammps/lammps-$LAMMPS_VERSION-$LAMMPS_MA_REVISION"

if [ -d $PREFIX ]; then
  echo "Error: $PREFIX exists"
  exit 127
fi

sh $SCRIPT_DIR/setup.sh
rm -rf $LOG
cd $BUILD_DIR/lammps-$LAMMPS_VERSION/src
start_info | tee -a $LOG
echo "[make]" | tee -a $LOG
check make mpi | tee -a $LOG
check make serial | tee -a $LOG
check make mpi mode=lib | tee -a $LOG
check make mpi mode=shlib | tee -a $LOG
check make serial mode=lib | tee -a $LOG
check make serial mode=shlib | tee -a $LOG
echo "[make install]" | tee -a $LOG
mkdir -p $PREFIX/bin $PREFIX/include $PREFIX/lib
cp -p lmp_mpi lmp_serial $PREFIX/bin
cp -p lammps.h $PREFIX/include
cp -p liblammps_* $PREFIX/lib
cp -rp $BUILD_DIR/lammps-$LAMMPS_VERSION/examples $PREFIX
cp -rp $BUILD_DIR/lammps-$LAMMPS_VERSION/potentials $PREFIX
finish_info | tee -a $LOG

cat << EOF > $BUILD_DIR/lammpsvars.sh
# lammps $(basename $0 .sh) $LAMMPS_VERSION $LAMMPS_MA_REVISION $(date +%Y%m%d-%H%M%S)
test -z "\$MA_ROOT_TOOL" && . $PREFIX_TOOL/env.sh
export LAMMPS_ROOT=$PREFIX
export LAMMPS_VERSION=$LAMMPS_VERSION
export LAMMPS_MA_REVISION=$LAMMPS_MA_REVISION
export PATH=\$LAMMPS_ROOT/bin:\$PATH
export LD_LIBRARY_PATH=\$LAMMPS_ROOT/lib:\$LD_LIBRARY_PATH
EOF
LAMMPSVARS_SH=$PREFIX_APPS/lammps/lammpsvars-$LAMMPS_VERSION-$LAMMPS_MA_REVISION.sh
rm -f $LAMMPSVARS_SH
cp -f $BUILD_DIR/lammpsvars.sh $LAMMPSVARS_SH
rm -f $BUILD_DIR/lammpsvars.sh
cp -f $LOG $PREFIX_APPS/lammps/
