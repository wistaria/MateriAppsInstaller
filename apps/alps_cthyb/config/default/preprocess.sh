set -u

rm -rf build
mkdir build
cd build

${CMAKE} -DCMAKE_INSTALL_PREFIX=${PREFIX} \
  -DCMAKE_BUILD_TYPE=Release \
  -DCMAKE_VERBOSE_MAKEFILE=1 \
  -DALPSCore_DIR=${ALPSCORE_ROOT}/share/ALPSCore \
  -DNFFT3_DIR=${NFFT_ROOT} \
  ../
