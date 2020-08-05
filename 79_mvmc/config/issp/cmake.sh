${CMAKE} \
  -DCMAKE_INSTALL_PREFIX=${PREFIX} \
  -DCONFIG=sekirei \
  ../ 2>&1 | tee -a $LOG
