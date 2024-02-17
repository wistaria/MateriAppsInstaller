rm -rf build
mkdir build
cd build

python3 ../configure.py --arch=arm-sve --prefix=${PREFIX} --verbose
