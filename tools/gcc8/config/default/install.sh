cd build
make install
if [ -f $PREFIX/bin/cc ]; then :; else
  ln -s gcc $PREFIX/bin/cc
fi
if [ -f $PREFIX/bin/c++ ]; then :; else
  ln -s g++ $PREFIX/bin/c++
fi
if [ -f $PREFIX/bin/f95 ]; then :; else
  ln -s gfortran $PREFIX/bin/f95
fi
