cd source

sh $(dirname $0)/../default/preprocess_common.sh

CC=${CC:-mpicc}
FC=${FC:-mpif90}
OMP_FLAG=${OMP_FLAG:-"-fopenmp"}
LIB=${LIB:-"-lscalapack -llapack -lblas -lfftw3 -lmpi -lpthread -lm -lgfortran"}

echo CC=$CC
echo FC=$FC
echo OMP_FLAG=$OMP_FLAG
echo LIB=$LIB

cat << EOF > makefile_head
CC = ${CC} ${MA_EXTRA_FLAGS} $OMP_FLAG -fcommon
FC = ${FC} ${MA_EXTRA_FLAGS} $OMP_FLAG -fcommon
LIB = ${LIB}
EOF

cat makefile_head makefile.org > makefile
