cd source

. $SCRIPT_DIR/../../scripts/util.sh
if check_fc $FC -fallow-argument-mismatch; then
  FCFLAGS="$FCFLAGS -fallow-argument-mismatch"
fi

sh $(dirname $0)/../default/preprocess_common.sh

MPICC=${MPICC:-"mpicc"}
MPIF90=${MPIF90:-"mpif90"}

CC=${CC:-"$($MPICC -show | cut -d' ' -f1)"}
FC=${FC:-"$($MPIF90 -show | cut -d' ' -f1)"}

MPICFLAGS=$($MPICC -show | cut -d' ' -f2- )
MPIF90FLAGS=$($MPIF90 -show | cut -d' ' -f2- )

CFLAGS="$CFLAGS $MPICFLAGS -O3 -Xpreprocessor -fopenmp -I/usr/local/include -Dkcomp -fcommon"
FCFLAGS="$FCFLAGS $MPIF90FLAGS -O3 -Xpreprocessor -fopenmp -Dkcomp"

LIB=${LIB:-"-L/usr/local/lib -lfftw3 -framework accelerate -lomp -lmpi -lscalapack -lmpi_usempif08 -lmpi_usempi_ignore_tkr -lmpi_mpifh -lgfortran"}

echo $CFLAGS

cat << EOF > makefile_head
CC = ${CC} ${CFLAGS} ${MA_EXTRA_FLAGS}
FC = ${FC} ${FCFLAGS} ${MA_EXTRA_FLAGS}
LIB = ${LIB}
EOF

cat makefile_head makefile.org > makefile
