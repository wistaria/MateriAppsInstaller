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

JMAKE="-j4"

sh $SCRIPT_DIR/setup.sh
rm -rf $LOG
cd $BUILD_DIR/lammps-$LAMMPS_VERSION/src
cd STUBS
make clean
make CC=icc
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
make CC=icc | tee -a $LOG

echo "[lib/awpmd]" | tee -a $LOG
cd $BUILD_DIR/lammps-$LAMMPS_VERSION/lib/awpmd
check make $JMAKE -f Makefile.mpicc | tee -a $LOG
check echo "user-awpmd_SYSLIB = -mkl" >> Makefile.lammps
echo "[lib/atc]" | tee -a $LOG
cd $BUILD_DIR/lammps-$LAMMPS_VERSION/lib/atc
check make $JMAKE -f Makefile.mpi EXTRAMAKE=Makefile.lammps.installed | tee -a $LOG
check echo "user-atc_SYSLIB = -mkl" >> Makefile.lammps
echo "[lib/colvars]" | tee -a $LOG
cd $BUILD_DIR/lammps-$LAMMPS_VERSION/lib/colvars
check make -f Makefile.g++ CXX=icpc | tee -a $LOG
echo "[lib/gpu]" | tee -a $LOG
cd $BUILD_DIR/lammps-$LAMMPS_VERSION/lib/gpu
cp Makefile.linux Makefile.gpu
sed -i -e 's/mpic++/mpicxx/' Makefile.gpu
check make CUDA_HOME=$CUDA_PATH $JMAKE -f Makefile.gpu | tee -a $LOG
cat << END >> Makefile.lammps
gpu_SYSINC =
gpu_SYSLIB =  -lcudart -lcuda
gpu_SYSPATH = -L${CUDA_PATH}/lib64
END
echo "[lib/h5md]" | tee -a $LOG
cd $BUILD_DIR/lammps-$LAMMPS_VERSION/lib/h5md
check make -f Makefile.h5cc | tee -a $LOG
check echo "h5md_SYSINC = -I$HDF5_ROOT/include" >> Makefile.lammps
check echo "h5md_SYSLIB = -lhdf5" >> Makefile.lammps
check echo "h5md_SYSPATH = -L$HDF5_ROOT/lib" >> Makefile.lammps
echo "[lib/meam]" | tee -a $LOG
cd $BUILD_DIR/lammps-$LAMMPS_VERSION/lib/meam
check make -f Makefile.ifort | tee -a $LOG
check echo "meam_SYSLIB = -lifcore -lsvml -liompstubs5 -limf" >> Makefile.lammps
check echo "meam_SYSPATH = -L$(dirname $(which ifort))/../../compiler/lib/intel64" >> Makefile.lammps
echo "[lib/poems]" | tee -a $LOG
cd $BUILD_DIR/lammps-$LAMMPS_VERSION/lib/poems
check make $JMAKE -f Makefile.icc | tee -a $LOG
echo "[lib/qmmm]" | tee -a $LOG
cd $BUILD_DIR/lammps-$LAMMPS_VERSION/lib/qmmm
check make $JMAKE -f Makefile.ifort | tee -a $LOG
echo "[lib/reax]" | tee -a $LOG
cd $BUILD_DIR/lammps-$LAMMPS_VERSION/lib/reax
check make $JMAKE -f Makefile.ifort | tee -a $LOG
echo "[lib/python]" | tee -a $LOG
cd $BUILD_DIR/lammps-$LAMMPS_VERSION/lib/python
check echo "python_SYSLIB = $(python-config --ldflags)" >> Makefile.lammps
check echo "python_SYSPATH = -L$PYTHON_ROOT/lib" >> Makefile.lammps
echo "[lib/smd]" | tee -a $LOG
cd $BUILD_DIR/lammps-$LAMMPS_VERSION/lib/smd
wget http://bitbucket.org/eigen/eigen/get/3.3.0.tar.gz -O eigen.tar.gz
tar xzf eigen.tar.gz
mv eigen-eigen-* eigen
ln -s eigen includelink

# src
cd $BUILD_DIR/lammps-$LAMMPS_VERSION/src

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

echo "[make]" | tee -a $LOG
cd $BUILD_DIR/lammps-$LAMMPS_VERSION/src
check make $JMAKE mpi | tee -a $LOG
check make $JMAKE mpi mode=lib | tee -a $LOG
check make $JMAKE mpi mode=shlib | tee -a $LOG
check make yes-gpu | tee -a $LOG
check make $JMAKE gpu | tee -a $LOG
check make $JMAKE gpu mode=lib | tee -a $LOG

echo "[make install]" | tee -a $LOG
cd $BUILD_DIR/lammps-$LAMMPS_VERSION/src
mkdir -p $PREFIX/bin $PREFIX/include $PREFIX/lib
cp -p lmp_mpi $PREFIX/bin
cp -p lmp_gpu $PREFIX/bin
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
export LD_LIBRARY_PATH=\$LAMMPS_ROOT/lib:\$TBBROOT/lib/intel64/gcc4.4:\$LD_LIBRARY_PATH
EOF
LAMMPSVARS_SH=$PREFIX_APPS/lammps/lammpsvars-$LAMMPS_VERSION-$LAMMPS_MA_REVISION.sh
rm -f $LAMMPSVARS_SH
cp -f $BUILD_DIR/lammpsvars.sh $LAMMPSVARS_SH
rm -f $BUILD_DIR/lammpsvars.sh
cp -f $LOG $PREFIX_APPS/lammps/
