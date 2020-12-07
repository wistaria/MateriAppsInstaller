set -u

rm -rf build
mkdir build
cd build

if [ -d /usr/include ]; then
  ../configure \
    --enable-languages=c,c++,fortran \
    --prefix=$PREFIX \
    --disable-multilib
else
  echo "#include <math.h>" > MA_header_check.c
  sysroot=$(${CC:-cc} -H -fsyntax-only MA_header_check.c 2>&1 | head -n1 | awk '{print $2}')
  sysroot=${sysroot%%/usr/*}
  rm MA_header_check.c

  ../configure \
    --enable-languages=c,c++,fortran \
    --prefix=$PREFIX \
    --disable-multilib \
    --with-sysroot=${sysroot} \
    --with-native-system-header-dir=/usr/include
fi
