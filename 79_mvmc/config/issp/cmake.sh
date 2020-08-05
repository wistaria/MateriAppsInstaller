${CMAKE} \
  -DCMAKE_INSTALL_PREFIX=${PREFIX} \
  -CONFIG=sekirei \
  ../ 2>&1 | tee -a $LOG
