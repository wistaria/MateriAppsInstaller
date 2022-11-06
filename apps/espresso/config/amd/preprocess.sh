set -u

rm -rf build
mkdir build
cd build

CC=${CC:-clang}
FC=${FC:-flang}
export CC
export FC

${CMAKE} \
  -DCMAKE_INSTALL_PREFIX=${PREFIX} \
  -DCMAKE_C_FLAGS="${MA_EXTRA_FLAGS}" \
  -DCMAKE_Fortran_FLAGS="${MA_EXTRA_FLAGS}" \
  -DQE_ENABLE_OPENMP=ON \
  -DQE_ENABLE_SCALAPACK=ON \
  -DSCALAPACK_LIBRARIES=${SCALAPACK_LIBRARIES} \
  ..
