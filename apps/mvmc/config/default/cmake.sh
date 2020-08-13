${CMAKE} \
  -DCMAKE_INSTALL_PREFIX=${PREFIX} \
  ../ 2>&1 | tee -a $LOG
