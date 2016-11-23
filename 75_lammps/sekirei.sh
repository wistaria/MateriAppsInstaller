#!/bin/sh

SCRIPT_DIR=$(cd "$(dirname $0)"; pwd)
. $SCRIPT_DIR/../util.sh
. $SCRIPT_DIR/version.sh
set_prefix

$SUDO_APPS true
. $PREFIX_TOOL/env.sh
LOG=$BUILD_DIR/lammps-$LAMMPS_VERSION-$LAMMPS_MA_REVISION.log
PREFIX="$PREFIX_APPS/lammps/lammps-$LAMMPS_VERSION-$LAMMPS_MA_REVISION"

if [ -d $PREFIX ]; then
  echo "Error: $PREFIX exists"
  exit 127
fi

JMAKE="-j4"

sh $SCRIPT_DIR/setup.sh
rm -rf $LOG
cd $BUILD_DIR/lammps-$LAMMPS_VERSION/src
cd STUBS
make clean
make CC=icc
start_info | tee -a $LOG
echo "[make]" | tee -a $LOG

# libs
## atc
echo "[lib/atc]" | tee -a $LOG
cd $BUILD_DIR/lammps-$LAMMPS_VERSION/lib/atc
sed -e 's/mpic++/mpicxx/' Makefile.mpic++ > Makefile.sekirei
sed -i -e 's/-lblas\s-llapack/-mkl/g' Makefile.lammps.installed
check make $JMAKE -f Makefile.sekirei | tee -a $LOG

## awpmd
echo "[lib/awpmd]" | tee -a $LOG
cd $BUILD_DIR/lammps-$LAMMPS_VERSION/lib/awpmd
sed -e 's/mpic++/mpicxx/' Makefile.mpicc > Makefile.sekirei
sed -i -e 's/-lblas\s-llapack/-mkl/g' Makefile.lammps.installed
check make $JMAKE -f Makefile.sekirei | tee -a $LOG

## colvars
echo "[lib/colvars]" | tee -a $LOG
cd $BUILD_DIR/lammps-$LAMMPS_VERSION/lib/colvars
sed -e 's/g++/icpc/g' Makefile.g++ > Makefile.icpc
check make $JMAKE -f Makefile.icpc | tee -a $LOG

## gpu
echo "[lib/gpu]" | tee -a $LOG
cd $BUILD_DIR/lammps-$LAMMPS_VERSION/lib/gpu
cp Makefile.linux Makefile.sekirei
sed -i -e 's/mpic++/mpicxx/' Makefile.sekirei
check make CUDA_HOME=$CUDA_PATH $JMAKE -f Makefile.sekirei | tee -a $LOG
cat << END > Makefile.lammps
gpu_SYSINC =
gpu_SYSLIB =  -lcudart -lcuda
gpu_SYSPATH = -L${CUDA_PATH}/lib64
END

## h5md
echo "[lib/h5md]" | tee -a $LOG
cd $BUILD_DIR/lammps-$LAMMPS_VERSION/lib/h5md
check make $JMAKE | tee -a $LOG

## meam
echo "[lib/meam]" | tee -a $LOG
icclib=`which ifort | cut -d '/' -f 1-5`/linux/compiler/lib/intel64

cd $BUILD_DIR/lammps-$LAMMPS_VERSION/lib/meam
sed -i -e 's/lompstub/liompstubs5/' Makefile.lammps.ifort
sed -i -e "/meam_SYSPATH/c\meam_SYSPATH = -L$icclib" Makefile.lammps.ifort
check make $JMAKE -f Makefile.ifort | tee -a $LOG

## poems
echo "[lib/poems]" | tee -a $LOG
cd $BUILD_DIR/lammps-$LAMMPS_VERSION/lib/poems
check make $JMAKE -f Makefile.icc | tee -a $LOG

## qmmm
echo "[lib/qmm]" | tee -a $LOG
cd $BUILD_DIR/lammps-$LAMMPS_VERSION/lib/qmmm
check make $JMAKE -f Makefile.ifort | tee -a $LOG

## reax
echo "[lib/reax]" | tee -a $LOG
cd $BUILD_DIR/lammps-$LAMMPS_VERSION/lib/reax
check make $JMAKE -f Makefile.ifort | tee -a $LOG

## smd
echo "[lib/smd]" | tee -a $LOG
cd $BUILD_DIR/lammps-$LAMMPS_VERSION/lib/smd
wget http://bitbucket.org/eigen/eigen/get/3.3.0.tar.gz -O eigen.tar.gz
tar xzf eigen.tar.gz
mv eigen-eigen-* eigen
ln -s eigen includelink

# src
cd $BUILD_DIR/lammps-$LAMMPS_VERSION/src

## enable package
echo "[enable packages]" | tee -a $LOG
check make yes-all | tee -a $LOG
check make no-kim | tee -a $LOG
check make no-kokkos | tee -a $LOG
check make no-user-molfile | tee -a $LOG
check make no-user-quip | tee -a $LOG
check make no-voronoi | tee -a $LOG
check make no-user-vtk | tee -a $LOG
check make no-gpu | tee -a $LOG

CCFLAGS="-g -O3 -fopenmp -restrict -I${HDF5_ROOT}/include -I${TBBROOT}/include -DLAMMPS_MEMALIGN=64 -xHost -fno-alias -ansi-alias -qoverride-limits"
LINKFLAGS="-g -O -L$HDF5_ROOT/lib -fopenmp"
LIBS="-L${PYTHON_ROOT}/lib -L${TBBROOT}/lib/intel64/gcc4.4 -ltbb -ltbbmalloc"

cd $BUILD_DIR/lammps-$LAMMPS_VERSION/src/MAKE
echo sed -i -e "/^\s*CCFLAGS\s*=/c\CCFLAGS = $CCFLAGS" Makefile.mpi | tee -a $LOG
sed -i -e "/^\s*CCFLAGS\s*=/c\CCFLAGS = $CCFLAGS" Makefile.mpi
echo sed -i -e "/^\s*LINKFLAGS\s*=/c\LINKFLAGS = $LINKFLAGS" Makefile.mpi | tee -a $LOG
sed -i -e "/^\s*LINKFLAGS\s*=/c\LINKFLAGS = $LINKFLAGS" Makefile.mpi
echo sed -i -e "/^\s*LIB\s*=/c\LIB = $LIBS" Makefile.mpi | tee -a $LOG
sed -i -e "/^\s*LIB\s*=/c\LIB = $LIBS" Makefile.mpi
cp Makefile.mpi Makefile.gpu

cd $BUILD_DIR/lammps-$LAMMPS_VERSION/src
check make $JMAKE mpi | tee -a $LOG
check make $JMAKE mpi mode=lib | tee -a $LOG

check make yes-gpu | tee -a $LOG
check make $JMAKE gpu | tee -a $LOG
check make $JMAKE gpu mode=lib | tee -a $LOG

echo "[make install]" | tee -a $LOG
$SUDO_APPS mkdir -p $PREFIX/bin $PREFIX/include $PREFIX/lib $PREFIX/examples
$SUDO_APPS cp -p lmp_mpi $PREFIX/bin
$SUDO_APPS cp -p lmp_gpu $PREFIX/bin
$SUDO_APPS cp -p lammps.h $PREFIX/include
$SUDO_APPS cp -p liblammps_* $PREFIX/lib
$SUDO_APPS cp -r $BUILD_DIR/lammps-$LAMMPS_VERSION/examples $PREFIX

finish_info | tee -a $LOG

cat << EOF > $BUILD_DIR/lammpsvars.sh
# lammps $(basename $0 .sh) $LAMMPS_VERSION $LAMMPS_MA_REVISION $(date +%Y%m%d-%H%M%S)
source \$(ls -1 /home/issp/materiapps/tool/python/*.sh | tail -n 1)
source \$(ls -1 /home/issp/materiapps/tool/hdf5/*.sh | tail -n 1)
export LAMMPS_ROOT=$PREFIX
export LAMMPS_VERSION=$LAMMPS_VERSION
export LAMMPS_MA_REVISION=$LAMMPS_MA_REVISION
export PATH=\$LAMMPS_ROOT/bin:\$PATH
export LD_LIBRARY_PATH=\$LAMMPS_ROOT/lib:\$TBBROOT/lib/intel64/gcc4.4:\$LD_LIBRARY_PATH
EOF
LAMMPSVARS_SH=$PREFIX_APPS/lammps/lammpsvars-$LAMMPS_VERSION-$LAMMPS_MA_REVISION.sh
$SUDO_APPS rm -f $LAMMPSVARS_SH
$SUDO_APPS cp -f $BUILD_DIR/lammpsvars.sh $LAMMPSVARS_SH
rm -f $BUILD_DIR/lammpsvars.sh
$SUDO_APPS cp -f $LOG $PREFIX_APPS/lammps/
