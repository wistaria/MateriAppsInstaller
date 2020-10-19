CFLAGS="-O3 ${OPT_FLAGS}" \
FFLAGS="-O3 ${OPT_FLAGS}" \
./configure \
  --prefix=${PREFIX} \
  --enable-openmp \
  --with-scalapack=yes \
  CC=icc FC=ifort F77=ifort F90=ifort MPIF90=mpiifort \
  2>&1 | tee -a $LOG

sed -i.bak -c 's/^\s*F90\s*=.*$/F90 = ifort/' make.inc
sed -i.bak -c 's/^\s*BLAS_LIBS\s*=.*$/BLAS_LIBS = -mkl=cluster/' make.inc
