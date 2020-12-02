rm -rf build
mkdir build
cd build

cmake \
  -DCMAKE_INSTALL_PREFIX=${PREFIX} \
  -DCMAKE_VERBOSE_MAKEFILE=1 \
  -DCMAKE_C_FLAGS="-O3 ${MA_EXTRA_FLAGS}" \
  -DCMAKE_Fortran_FLAGS="-O3 ${MA_EXTRA_FLAGS}" \
  ../
