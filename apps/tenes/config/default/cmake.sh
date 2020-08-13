${CMAKE:-cmake} \
  -DCMAKE_INSTALL_PREFIX=$PREFIX \
  ../ | tee -a $LOG
