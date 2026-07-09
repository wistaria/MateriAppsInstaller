set -u

# ALAMODE needs spglib (FFT is provided by Intel MKL here). On ohtaka spglib
# comes from the MateriApps spglib tool; otherwise export SPGLIB_ROOT yourself.
: "${SPGLIB_ROOT:?SPGLIB_ROOT is not set. Install the spglib tool or export SPGLIB_ROOT before building alamode.}"

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
