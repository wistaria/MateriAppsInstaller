rm -rf build
mkdir build
cd build

python3 ../configure.py --arch=fujitsu-a64fx-ea --prefix=${PREFIX} --verbose
