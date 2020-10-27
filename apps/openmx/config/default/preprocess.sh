sh $(dirname $0)/../default/preprocess_common.sh

CC=${CC:-mpicc}
FC=${FC:-mpif90}

cat << EOF > makefile_head
CC = ${CC} ${MA_EXTRA_FLAGS} -fopenmp 
FC = ${FC} ${MA_EXTRA_FLAGS} -fopenmp 
LIB = ${LIB}
EOF

cat makefile_head makefile.org > makefile
