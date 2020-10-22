./configure \
  --prefix=$PREFIX \
  --enable-shared \
  CC=`which icc` \
  CFLAGS="${MA_EXTRA_FLAGS}" \
  2>&1 | tee -a $LOG
