${CMAKE} \
  -DCMAKE_INSTALL_PREFIX=${PREFIX} \
  -DCONFIG=gcc \
  ../ 2>&1 | tee -a $LOG
