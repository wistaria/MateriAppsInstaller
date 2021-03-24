set -u

rm -rf build && mkdir -p build && cd build
${CMAKE} -DCMAKE_INSTALL_PREFIX=$PREFIX -DBUILD_TESTING=OFF ..
