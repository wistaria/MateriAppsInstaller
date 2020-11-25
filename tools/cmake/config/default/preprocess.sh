set -u

rm -rf build && mkdir -p build && cd build
../bootstrap --prefix=$PREFIX
