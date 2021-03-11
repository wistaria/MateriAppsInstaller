set -u

rm -rf build
mkdir build
cd build

${CMAKE} \
  -DCMAKE_INSTALL_PREFIX=${PREFIX} \
  -DCMAKE_C_FLAGS="${MA_EXTRA_FLAGS}" \
  -DCMAKE_Fortran_FLAGS="${MA_EXTRA_FLAGS}" \
  -DCMAKE_VERBOSE_MAKEFILE=1 \
  -DCONFIG=fujitsu \
  ../
