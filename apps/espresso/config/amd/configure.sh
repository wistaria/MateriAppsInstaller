CFLAGS="-O3 ${OPT_FLAGS}" \
FFLAGS="-O3 ${OPT_FLAGS}" \
./configure \
  --prefix=${PREFIX} \
  --enable-openmp \
  --with-scalapack=yes \
  CC=clang FC=flang F77=flang F90=flang MPIF90=mpifort \
  2>&1 | tee -a $LOG

set -u

sed -i.bak -c 's/^\s*F90\s*=.*$/F90 = flang/' make.inc
sed -i.bak -c "s@^\\s\*BLAS_LIBS\\s\*=.\*\$@BLAS_LIBS = -I${AOCL_ROOT}/include -L${AOCL_ROOT}/lib -lblis-mt@" make.inc
sed -i.bak -c "s@^\\s\*LAPACK_LIBS\\s\*=.\*\$@LAPACK_LIBS = -I${AOCL_ROOT}/include -L${AOCL_ROOT}/lib -lflame@" make.inc
sed -i.bak -c "s@^\\s\*SCALAPACK_LIBS\\s\*=.\*\$@SCALAPACK_LIBS = -I${AOCL_ROOT}/include -L${AOCL_ROOT}/lib -lscalapack@" make.inc
sed -i.bak -c "s@^\\s\*SCALAPACK_LIBS\\s\*=.\*\$@SCALAPACK_LIBS = -I${AOCL_ROOT}/include -L${AOCL_ROOT}/lib -lscalapack@" make.inc
sed -i.bak -c "s@^\\s\*FFT_LIBS\\s\*=.\*\$@FFT_LIBS = -I${AOCL_ROOT}/include -L${AOCL_ROOT}/lib -lfftw@" make.inc
