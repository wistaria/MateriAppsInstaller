cd source

sh $(dirname $0)/../default/preprocess_common.sh

CC=${CC:-mpiicc}
FC=${FC:-mpiifort}
OMP_FLAG=${OMP_FLAG:-"-qopenmp"}

echo CC=${CC}
echo FC=${FC}

cat << EOF > makefile_head
CC = ${CC} ${MA_EXTRA_FLAGS} $OMP_FLAG -I${MKLROOT}/include/fftw $MKL_LIB -fcommon
FC = ${FC} ${MA_EXTRA_FLAGS} $OMP_FLAG $MKL_LIB -fcommon
LIB = $MKL_LIB -lifcore
EOF

cat makefile_head makefile.org > makefile
