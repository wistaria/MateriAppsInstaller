${CMAKE} \
  -DCMAKE_INSTALL_PREFIX=${PREFIX} \
  -DCONFIG=fujitsu \
  ../ 2>&1 | tee -a $LOG
