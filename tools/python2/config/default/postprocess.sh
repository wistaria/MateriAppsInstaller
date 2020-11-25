. $UTIL_SH

export LD_LIBRARY_PATH=$PREFIX/lib:$LD_LIBRARY_PATH

check $PREFIX/bin/python2 -m ensurepip

echo "[setuptools]"
check $PREFIX/bin/pip2 install setuptools wheel

echo "[numpy]"
check $PREFIX/bin/pip2 install numpy

echo "[scipy]" | tee -a $LOG
check $PREFIX/bin/pip2 install scipy

echo "[matplotlib]" | tee -a $LOG
check $PREFIX/bin/pip2 install matplotlib
# echo "change backend of matplotlib to Agg" | tee -a $LOG
# sed -i 's/backend\s*:\s*TkAgg/backend : Agg/' $PREFIX/lib/python$PVERSION/site-packages/matplotlib/mpl-data/matplotlibrc

echo "[jupyter]" 
check $PREFIX/bin/pip2 install sphinx jupyter

echo "[mock]"
check $PREFIX/bin/pip2 install mock

echo "[toml]"
check $PREFIX/bin/pip2 install toml

echo "[Cython]" 
check $PREFIX/bin/pip2 install Cython

echo "[mpi4py]"
check $PREFIX/bin/pip2 install mpi4py
