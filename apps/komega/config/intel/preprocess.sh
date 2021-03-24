set -u

if [ -z ${FC+defined} ]; then
  for m in mpifort mpiifort; do
    FC=$(which $m 2> /dev/null)
    test "$($FC --version 2> /dev/null | head -1 | cut -d ' ' -f 1)" = "ifort" && break
    FC=
  done
fi
export FC

./configure --prefix=$PREFIX --with-mpi

sed -i.back 's/^pic_flag=""/pic_flag="-fPIC"/' libtool
sed -i.back 's/^wl=""/wl="-Wl,"/' libtool
find . -name Makefile | xargs sed -i.back 's/^BLAS_LIBS\s*=.*$/BLAS_LIBS = -mkl=cluster/'
