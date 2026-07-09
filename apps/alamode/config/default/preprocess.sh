set -u

# ALAMODE needs spglib and FFTW3. On ohtaka these come from the MateriApps
# spglib / fftw tools; otherwise export SPGLIB_ROOT / FFTW3_ROOT yourself.
: "${SPGLIB_ROOT:?SPGLIB_ROOT is not set. Install the spglib tool or export SPGLIB_ROOT before building alamode.}"
: "${FFTW3_ROOT:?FFTW3_ROOT is not set. Install the fftw tool or export FFTW3_ROOT before building alamode.}"

rm -rf build
mkdir build
cd build

${CMAKE} \
  -DCMAKE_INSTALL_PREFIX=${PREFIX} \
  -DCMAKE_VERBOSE_MAKEFILE=1 \
  -DSPGLIB_ROOT=${SPGLIB_ROOT} \
  -DFFTW3_ROOT=${FFTW3_ROOT} \
  -DCMAKE_CXX_FLAGS="-O3 ${MA_EXTRA_FLAGS}" \
  ../
