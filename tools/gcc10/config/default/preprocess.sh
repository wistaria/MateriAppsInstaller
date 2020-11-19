set -u

rm -rf build
mkdir build
cd build

../configure --enable-languages=c,c++,fortran --prefix=$PREFIX --disable-multilib
