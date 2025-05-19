set -u

rm -rf build
mkdir build
cd build

${CMAKE:-cmake} \
  -DCMAKE_INSTALL_PREFIX=$PREFIX \
  -DCMAKE_VERBOSE_MAKEFILE=1 \
  -DCMAKE_BUILD_TYPE=Release \
  ../
