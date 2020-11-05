MPICC=${MPICC:-"mpicc"}
MPIF90=${MPIF90:-"mpif90"}

CC=${CC:-"$($MPICC -show | cut -d' ' -f1)"}
FC=${FC:-"$($MPIF90 -show | cut -d' ' -f1)"}

MPICFLAGS=$($MPICC -show | cut -d' ' -f2- )
MPIF90FLAGS=$($MPIF90 -show | cut -d' ' -f2- )

CFLAGS=${CFLAGS:-"$MPICFLAGS -O3 -Xpreprocessor -fopenmp -lomp -I/usr/local/include -Dkcomp"}
FCFLAGS=${CFLAGS:-"$MPIF90FLAGS -O3 -fopenmp -Dkcomp -fallow-argument-mismatch"}

LIB=${LIB:-"-L/usr/local/lib -L/usr/local/lib/gcc/8 -lfftw3 -framework accelerate -lmpi -lscalapack -lomp -lmpi_usempif08 -lmpi_usempi_ignore_tkr -lmpi_mpifh -lgfortran"}

CC="${CC} ${CFLAGS}" FC="$FC $FCFLAGS" LIB=$LIB make | tee -a $LOG
