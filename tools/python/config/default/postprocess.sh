echo "[pip]" | tee -a $LOG
$PREFIX/bin/python2 get-pip.py --prefix=$PREFIX 2>&1 | tee -a $LOG

echo "[numpy]" | tee -a $LOG
$PREFIX/bin/pip2 install numpy 2>&1 | tee -a $LOG

echo "[scipy]" | tee -a $LOG
$PREFIX/bin/pip2 install scipy 2>&1 | tee -a $LOG

echo "[matplotlib]" | tee -a $LOG
$PREFIX/bin/pip2 install matplotlib | tee -a $LOG
# echo "change backend of matplotlib to Agg" | tee -a $LOG
# sed -i 's/backend\s*:\s*TkAgg/backend : Agg/' $PREFIX/lib/python$PVERSION/site-packages/matplotlib/mpl-data/matplotlibrc

echo "[jupyter]" | tee -a $LOG
$PREFIX/bin/pip2 install sphinx jupyter | tee -a $LOG

echo "[mock]" | tee -a $LOG
$PREFIX/bin/pip2 install mock | tee -a $LOG

echo "[toml]" | tee -a $LOG
$PREFIX/bin/pip2 install toml | tee -a $LOG

echo "[Cython]" | tee -a $LOG
$PREFIX/bin/pip2 install Cython | tee -a $LOG

echo "[mpi4py]" | tee -a $LOG
$PREFIX/bin/pip2 install mpi4py | tee -a $LOG
