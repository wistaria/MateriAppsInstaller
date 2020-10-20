CFLAGS="-O3 ${MA_EXTRA_FLAGS}" \
FFLAGS="-O3 ${MA_EXTRA_FLAGS}" \
./configure \
  --prefix=${PREFIX} \
  --enable-openmp \
  --with-scalapack=yes \
  CC=${CC} FC=${FC} F77=${FC} F90=${FC} CPP=${CPP} \
  2>&1 | tee -a $LOG
