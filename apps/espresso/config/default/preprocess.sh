make veryclean

set -e

. $UTIL_SH
if check_fc ${FC:-gfortran} -fallow-argument-mismatch; then
  FFLAGS="${FFLAGS} -fallow-argument-mismatch"
fi

CFLAGS="-O3 ${CFLAGS} ${MA_EXTRA_FLAGS}" \
FFLAGS="-O3 ${FFLAGS} ${MA_EXTRA_FLAGS}" \
./configure \
  --prefix=${PREFIX} \
  --enable-openmp \
  --with-scalapack=yes \
  CC=${CC} FC=${FC} F77=${FC} F90=${FC} CPP=${CPP} \
  2>&1 | tee -a $LOG

sed -i.bak "s@^[ ]*F90[ ]*=.*\$@F90 = ${FC}@" make.inc
