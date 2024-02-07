rm -rf build
mkdir build
cd build

python3 ../configure.py --arch=fujitsu-fx100 --prefix=${PREFIX} --verbose
