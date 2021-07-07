set -u

rm -rf build
mkdir build
cd build

${CMAKE} -DCMAKE_INSTALL_PREFIX=${PREFIX} \
  -DBuild_Documentation=OFF \
  ../
