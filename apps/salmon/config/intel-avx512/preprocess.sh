rm -rf build
mkdir build
cd build

python3 ../configure.py --arch=intel-avx512 --prefix=${PREFIX} --verbose
