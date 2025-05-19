set -u

rm -rf build
mkdir build
cd build


if [ -z ${CC+defined} ]; then
  for m in mpicc mpiicc; do
    CC=$(which $m 2> /dev/null)
    test "$($CC --version 2> /dev/null | head -1 | cut -d ' ' -f 2)" = "oneAPI" && break
    test "$($CC --version 2> /dev/null | head -1 | cut -d ' ' -f 1)" = "icc" && 
break
    CC=$(which icx || which icc)
  done
fi
if [ -z ${CXX+defined} ]; then
  for m in mpicxx mpic++ mpiicpc; do
    CXX=$(which $m 2> /dev/null)
    test "$($CXX --version 2> /dev/null | head -1 | cut -d ' ' -f 2)" = "oneAPI" && break
    test "$($CXX --version 2> /dev/null | head -1 | cut -d ' ' -f 1)" = "icpc" && break
    CXX=$(which icpx || which icpc)
  done
fi
export CC
export CXX

${CMAKE} -DCMAKE_INSTALL_PREFIX=${PREFIX} \
  -DCMAKE_BUILD_TYPE=Release \
  -DCMAKE_VERBOSE_MAKEFILE=1 \
  -DALPSCore_DIR=${ALPSCORE_ROOT}/share/ALPSCore \
  -DNFFT3_DIR=${NFFT_ROOT} \
  ../
