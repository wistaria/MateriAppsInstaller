cd source

make clean
mkdir -p $PREFIX/bin
make ${MAKE_J} all DESTDIR=$PREFIX/bin
