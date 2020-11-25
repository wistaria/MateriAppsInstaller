set -u

. $UTIL_SH

check mpicxx mpicheck.cpp -o mpicheck
check ${MPIEXEC_CMD} ./mpicheck
