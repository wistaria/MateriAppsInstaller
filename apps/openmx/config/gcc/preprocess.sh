rm -rf build
mkdir build
cd build

cmake \
  -DCMAKE_INSTALL_PREFIX=${PREFIX} \
  -DCMAKE_VERBOSE_MAKEFILE=1 \
  -DCMAKE_C_COMPILER=gcc \
  -DCMAKE_Fortran_COMPILER=gfortran \
  -DCMAKE_C_FLAGS="${MA_EXTRA_FLAGS}" \
  -DCMAKE_Fortran_FLAGS="${MA_EXTRA_FLAGS}" \
  ../
