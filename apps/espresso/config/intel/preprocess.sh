set -u

rm -rf build
mkdir build
cd build

CC=${CC:-icx}
FC=${FC:-ifx}
export CC
export FC

if [ -n "$SCALAPACK_ROOT" ]; then
  scalapack_DIR=${SCALAPACK_ROOT}
  export scalapack_DIR
  ${CMAKE} \
    -DCMAKE_INSTALL_PREFIX=${PREFIX} \
    -DCMAKE_C_FLAGS="${MA_EXTRA_FLAGS}" \
    -DCMAKE_Fortran_FLAGS="${MA_EXTRA_FLAGS}" \
    -DQE_ENABLE_OPENMP=ON \
    -DQE_ENABLE_SCALAPACK=ON \
    ..
else
  SCALAPACK_LIBRARIES=${SCALAPACK_LIBRARIES:--mkl=cluster}
  ${CMAKE} \
    -DCMAKE_INSTALL_PREFIX=${PREFIX} \
    -DCMAKE_C_FLAGS="${MA_EXTRA_FLAGS}" \
    -DCMAKE_Fortran_FLAGS="${MA_EXTRA_FLAGS}" \
    -DQE_ENABLE_OPENMP=ON \
    -DQE_ENABLE_SCALAPACK=ON \
    -DSCALAPACK_LIBRARIES=${SCALAPACK_LIBRARIES} \
    ..
fi
