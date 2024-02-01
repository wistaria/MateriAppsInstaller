rm -rf build
mkdir build
cd build

python3 ../configure.py --arch=nvhpc-openacc-cuda --prefix=${PREFIX} --verbose
