# Intel compiler seems not to work?
# And so use GCC

./configure \
  --prefix=$PREFIX \
  --enable-shared \
  --enable-optimizations \
  2>&1 | tee -a $LOG
