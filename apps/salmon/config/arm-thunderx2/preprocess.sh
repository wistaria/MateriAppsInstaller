rm -rf build
mkdir build
cd build

python3 ../configure.py --arch=arm-thunderx2 --prefix=${PREFIX} --verbose
