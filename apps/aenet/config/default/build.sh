cd lib
make
cd ../src

make clean
make -f makefiles/Makefile.gfortran_serial
make clean
make -f makefiles/Makefile.gfortran_mpi
