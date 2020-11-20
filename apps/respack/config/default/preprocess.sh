rm -rf build
mkdir build
cd build

${CMAKE} \
  -DCMAKE_INSTALL_PREFIX=${PREFIX} \
  -DCMAKE_BUILD_TYPE=Release \
  -DCMAKE_VERBOSE_MAKEFILE=1 \
  -DCMAKE_Fortran_FLAGS="${MA_EXTRA_FLAGS}" \
  ../
