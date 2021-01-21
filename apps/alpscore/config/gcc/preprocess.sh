set -u

rm -rf build
mkdir build
cd build

${CMAKE} -DCMAKE_INSTALL_PREFIX=${PREFIX} \
  -DCMAKE_C_COMPILER=gcc -DCMAKE_CXX_COMPILER=g++ \
  -DDocumentation=OFF \
  ../
