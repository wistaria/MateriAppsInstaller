set -u

rm -rf build
mkdir build
cd build

${CMAKE:-cmake} \
  -DCMAKE_INSTALL_PREFIX=$PREFIX \
  -DCMAKE_CXX_COMPILER=`which icpc` \
  -DCMAKE_CXX_FLAGS="$MA_EXTRA_FLAGS" \
  -DCMAKE_VERBOSE_MAKEFILE=1 \
  -DCMAKE_BUILD_TYPE=Release \
  ../
