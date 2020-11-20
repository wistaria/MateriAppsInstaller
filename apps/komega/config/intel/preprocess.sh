FC=${FC:-mpiifort}
./configure --prefix=$PREFIX --with-mpi

sed -i.back -c 's/^pic_flag=""/pic_flag="-fPIC"/' libtool
sed -i.back -c 's/^wl=""/wl="-Wl,"/' libtool
sed -i.back -c 's/^BLAS_LIBS\s*=.*$/BLAS_LIBS = -mkl=cluster/' Makefile
