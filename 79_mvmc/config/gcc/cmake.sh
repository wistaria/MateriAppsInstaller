${CMAKE} \
  -DCMAKE_INSTALL_PREFIX=${PREFIX} \
  -CONFIG=gcc \
  ../ 2>&1 | tee -a $LOG
