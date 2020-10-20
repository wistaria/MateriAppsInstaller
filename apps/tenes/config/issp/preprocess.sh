${CMAKE:-cmake} \
  -DCMAKE_INSTALL_PREFIX=$PREFIX \
  -DCMAKE_CXX_COMPILER=`which icpc` \
  ../ | tee -a $LOG
