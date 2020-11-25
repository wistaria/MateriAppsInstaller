. $UTIL_SH

export LD_LIBRARY_PATH=$PREFIX/lib:$LD_LIBRARY_PATH

echo "[setuptools]"
check $PREFIX/bin/pip3 install setuptools wheel

echo "[numpy]"
check $PREFIX/bin/pip3 install numpy

echo "[scipy]" | tee -a $LOG
check $PREFIX/bin/pip3 install scipy

echo "[matplotlib]" | tee -a $LOG
check $PREFIX/bin/pip3 install matplotlib
# echo "change backend of matplotlib to Agg" | tee -a $LOG
# sed -i 's/backend\s*:\s*TkAgg/backend : Agg/' $PREFIX/lib/python$PVERSION/site-packages/matplotlib/mpl-data/matplotlibrc

echo "[jupyter]" 
check $PREFIX/bin/pip3 install sphinx jupyter

echo "[mock]"
check $PREFIX/bin/pip3 install mock

echo "[toml]"
check $PREFIX/bin/pip3 install toml

echo "[Cython]" 
check $PREFIX/bin/pip3 install Cython

echo "[mpi4py]"
check $PREFIX/bin/pip3 install mpi4py
