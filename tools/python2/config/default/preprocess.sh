./configure \
  --prefix=$PREFIX \
  --enable-shared \
  --enable-optimizations \
  2>&1 | tee -a $LOG
