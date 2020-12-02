rm -rf build
mkdir build
cd build

CC=${CC:-icc}
FC=${FC:-ifort}

cmake \
  -DFFTW_ROOT=${MKLROOT}/include/fftw \
  -DCMAKE_INSTALL_PREFIX=${PREFIX} \
  -DCMAKE_VERBOSE_MAKEFILE=1 \
  -DCMAKE_C_FLAGS="${MA_EXTRA_FLAGS}" \
  -DCMAKE_Fortran_FLAGS="${MA_EXTRA_FLAGS}" \
  ../
