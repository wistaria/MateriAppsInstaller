set -u

rm -rf build
mkdir build
cd build

${CMAKE} \
  -DCMAKE_INSTALL_PREFIX=${PREFIX} \
  -DCMAKE_VERBOSE_MAKEFILE=1 \
  -DUSE_MKL_FFT=yes \
  -DSPGLIB_ROOT=${SPGLIB_ROOT} \
  -DCMAKE_CXX_FLAGS="-O3 ${MA_EXTRA_FLAGS}" \
  -DCMAKE_C_COMPILER=icc \
  -DCMAKE_CXX_COMPILER=icpc \
  ../
