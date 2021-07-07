set -u

rm -rf build
mkdir build
cd build

${CMAKE} ../
