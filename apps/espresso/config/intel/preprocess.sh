rm -f make.inc

set -e

CC=${CC:-icc}
FC=${FC:-ifort}
F90=${FC}
MPIF90=${MPIF90:-mpiifort}
BLAS_LIBS=${BLAS_LIBS:-"-mkl=cluster"}

CFLAGS="-O3 ${MA_EXTRA_FLAGS}" \
FFLAGS="-O3 ${MA_EXTRA_FLAGS}" \
./configure \
  --prefix=${PREFIX} \
  --enable-openmp \
  --with-scalapack=yes \
  CC=icc FC=ifort F77=ifort F90=ifort MPIF90=mpiifort

sed -i.bak 's/^\s*F90\s*=.*$/F90 = ifort/' make.inc
sed -i.bak "s/^\\s*BLAS_LIBS\\s*=.*$/BLAS_LIBS = ${BLAS_LIBS}/" make.inc
sed -i.bak 's/-x\s*f95-cpp-input/-cpp/' make.inc
