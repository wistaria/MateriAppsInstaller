rm -rf build
mkdir build
cd build

python3 ../configure.py --arch=intel-avx2-epyc --prefix=${PREFIX} --verbose
