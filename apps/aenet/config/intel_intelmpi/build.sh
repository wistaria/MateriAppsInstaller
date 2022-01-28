cd lib
make
cd ../src

make clean
make -f makefiles/Makefile.ifort_serial
make clean
make -f makefiles/Makefile.ifort_intelmpi
