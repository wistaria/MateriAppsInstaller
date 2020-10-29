sh $(dirname $0)/../default/preprocess_common.sh

CC=${CC:-mpiicc}
FC=${FC:-mpiifort}

cat << EOF > makefile_head
CC = ${CC} ${MA_EXTRA_FLAGS} -qopenmp -I${MKLROOT}/include/fftw -mkl=cluster
FC = ${FC} ${MA_EXTRA_FLAGS} -qopenmp -mkl=cluster
LIB = -mkl=cluster -lifcore
EOF

cat makefile_head makefile.org > makefile
