set -u

FC=${FC:-mpifort}
export FC

./configure --prefix=$PREFIX --with-mpi
