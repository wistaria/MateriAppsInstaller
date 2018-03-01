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
start_info | tee -a $LOG
echo "[enable packages]" | tee -a $LOG
cd $BUILD_DIR/lammps-$LAMMPS_VERSION/src
check make yes-all | tee -a $LOG
check make no-gpu | tee -a $LOG
check make no-kim | tee -a $LOG
check make no-kokkos | tee -a $LOG
check make no-mscg | tee -a $LOG
check make no-voronoi | tee -a $LOG
check make no-user-molfile | tee -a $LOG
check make no-user-quip | tee -a $LOG
check make no-user-vtk | tee -a $LOG

echo "[STUBS]" | tee -a $LOG
cd $BUILD_DIR/lammps-$LAMMPS_VERSION/src/STUBS
make | tee -a $LOG

echo "[lib/awpmd]" | tee -a $LOG
cd $BUILD_DIR/lammps-$LAMMPS_VERSION/lib/awpmd
check make -f Makefile.mpicc | tee -a $LOG
echo "[lib/atc]" | tee -a $LOG
cd $BUILD_DIR/lammps-$LAMMPS_VERSION/lib/atc
check make -f Makefile.mpic++ | tee -a $LOG
echo "[lib/colvars]" | tee -a $LOG
cd $BUILD_DIR/lammps-$LAMMPS_VERSION/lib/colvars
check make -f Makefile.g++ | tee -a $LOG
echo "[lib/h5md]" | tee -a $LOG
cd $BUILD_DIR/lammps-$LAMMPS_VERSION/lib/h5md
check make -f Makefile.h5cc | tee -a $LOG
echo "h5md_SYSINC = -I$HDF5_ROOT/include" >> Makefile.lammps
echo "h5md_SYSLIB = -lhdf5" >> Makefile.lammps
echo "h5md_SYSPATH = -L$HDF5_ROOT/lib" >> Makefile.lammps
echo "[lib/meam]" | tee -a $LOG
cd $BUILD_DIR/lammps-$LAMMPS_VERSION/lib/meam
check make -f Makefile.gfortran | tee -a $LOG
echo "[lib/poems]" | tee -a $LOG
cd $BUILD_DIR/lammps-$LAMMPS_VERSION/lib/poems
check make -f Makefile.g++ | tee -a $LOG
echo "[lib/qmmm]" | tee -a $LOG
cd $BUILD_DIR/lammps-$LAMMPS_VERSION/lib/qmmm
check make -f Makefile.gfortran | tee -a $LOG
echo "[lib/reax]" | tee -a $LOG
cd $BUILD_DIR/lammps-$LAMMPS_VERSION/lib/reax
check make -f Makefile.gfortran | tee -a $LOG
echo "[lib/python]" | tee -a $LOG
cd $BUILD_DIR/lammps-$LAMMPS_VERSION/lib/python
check echo "python_SYSLIB = $(python-config --ldflags)" >> Makefile.lammps
check echo "python_SYSPATH = -L$PYTHON_ROOT/lib" >> Makefile.lammps
echo "[lib/smd]" | tee -a $LOG
cd $BUILD_DIR/lammps-$LAMMPS_VERSION/lib/smd
check echo "user-smd_SYSINC = -I$EIGEN3_ROOT/include/eigen3" >> Makefile.lammps

echo "[make mpi]" | tee -a $LOG
cd $BUILD_DIR/lammps-$LAMMPS_VERSION/src
check make mpi | tee -a $LOG
check make mpi mode=lib | tee -a $LOG
check make mpi mode=shlib | tee -a $LOG

echo "[lib/atc serial]" | tee -a $LOG
cd $BUILD_DIR/lammps-$LAMMPS_VERSION/lib/atc
check make -f Makefile.serial clean | tee -a $LOG
check make -f Makefile.serial EXTRAMAKE=Makefile.lammps.installed | tee -a $LOG

echo "[make serial]" | tee -a $LOG
cd $BUILD_DIR/lammps-$LAMMPS_VERSION/src
check make no-mpiio no-user-lb
check make serial | tee -a $LOG
check make serial mode=lib | tee -a $LOG
check make serial mode=shlib | tee -a $LOG

echo "[make install]" | tee -a $LOG
cd $BUILD_DIR/lammps-$LAMMPS_VERSION/src
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
