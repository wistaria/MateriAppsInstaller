./bootstrap.sh
if [ -n "$FFTW3_DIR" ]; then
./configure --enable-all --enable-openmp --enable-julia --with-fftw3=$FFTW3_DIR --prefix=$PREFIX
else
./configure --enable-all --enable-openmp --enable-julia --prefix=$PREFIX
fi
