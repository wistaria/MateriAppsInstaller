${CMAKE} \
  -DCMAKE_INSTALL_PREFIX=${PREFIX} \
  -DCONFIG=intel \
  ../ 2>&1 | tee -a $LOG
