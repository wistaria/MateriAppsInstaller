set -u

rm -rf build
mkdir build
cd build

if [ -z ${CC+defined} ]; then
  for m in mpicc mpiicc; do
    CC=$(which $m 2> /dev/null)
    test "$($CC --version 2> /dev/null | head -1 | cut -d ' ' -f 1)" = "icc" && break
    CC=icc
  done
fi
if [ -z ${FC+defined} ]; then
  for m in mpifort mpiifort; do
    FC=$(which $m 2> /dev/null)
    test "$($FC --version 2> /dev/null | head -1 | cut -d ' ' -f 1)" = "ifort" && break
    FC=ifort
  done
fi
export CC
export FC

${CMAKE} \
  -DCMAKE_INSTALL_PREFIX=${PREFIX} \
  -DCMAKE_C_FLAGS_RELEASE="-O3 -DNDEBUG -DHAVE_SSE2" \
  -DCMAKE_C_FLAGS="${MA_EXTRA_FLAGS}" \
  -DCMAKE_Fortran_FLAGS_RELEASE="-O3 -DNDEBUG -DHAVE_SSE2" \
  -DCMAKE_Fortran_FLAGS="${MA_EXTRA_FLAGS}" \
  -DCMAKE_VERBOSE_MAKEFILE=1 \
  -DUSE_SCALAPACK=ON \
  -DSCALAPACK_LIBRARIES="-mkl=cluster" \
  ../
