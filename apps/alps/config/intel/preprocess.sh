set -u

rm -rf build
mkdir build
cd build

if [ -z ${CC+defined} ]; then
  for m in mpicc mpiicc; do
    CC=$(which $m 2> /dev/null)
    test "$($CC --version 2> /dev/null | head -1 | cut -d ' ' -f 2)" = "oneAPI" && break
    test "$($CC --version 2> /dev/null | head -1 | cut -d ' ' -f 1)" = "icc" && break
    CC=$(which icx || which icc)
  done
fi
if [ -z ${CXX+defined} ]; then
  for m in mpicxx mpic++ mpiicpc; do
    CXX=$(which $m 2> /dev/null)
    test "$($CXX --version 2> /dev/null | head -1 | cut -d ' ' -f 2)" = "oneAPI" && break
    test "$($CXX --version 2> /dev/null | head -1 | cut -d ' ' -f 1)" = "icpc" && break
    CXX=$(which icpx || icpc)
  done
fi
export CC
export CXX

. $SCRIPT_DIR/../../tools/python3/find.sh
if [ ${MA_HAVE_PYTHON3} = "yes" ]; then
  ${CMAKE} -DCMAKE_INSTALL_PREFIX=$PREFIX \
    -DALPS_ENABLE_OPENMP=ON -DALPS_ENABLE_OPENMP_WORKER=ON \
    -DALPS_BUILD_TESTS=ON -DALPS_BUILD_PYTHON=ON \
    -DPYTHON_INTERPRETER=${MA_PYTHON3} \
    ..
else
  ${CMAKE} -DCMAKE_INSTALL_PREFIX=$PREFIX \
    -DALPS_ENABLE_OPENMP=ON -DALPS_ENABLE_OPENMP_WORKER=ON \
    -DALPS_BUILD_TESTS=ON \
    ..
fi
