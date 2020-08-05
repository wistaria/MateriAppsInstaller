${CMAKE} \
  -DCMAKE_INSTALL_PREFIX=${PREFIX} \
  -CONFIG=intel \
  ../ 2>&1 | tee -a $LOG
