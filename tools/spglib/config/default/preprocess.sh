set -u

rm -rf build && mkdir -p build && cd build
cmake -DCMAKE_INSTALL_PREFIX=$PREFIX ../
