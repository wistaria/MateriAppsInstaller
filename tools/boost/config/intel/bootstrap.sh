check sh bootstrap.sh -with-toolset=intel-linux | tee -a $LOG
./b2 --prefix=$PREFIX install | tee -a $LOG
