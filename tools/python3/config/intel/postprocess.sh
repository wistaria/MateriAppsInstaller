. $UTIL_SH

if [ -z ${CC} ]; then
  CC=icc
fi
if [ -z ${CXX} ]; then
  CXX=icpc
fi
export CC
export CXX

export LD_LIBRARY_PATH=$PREFIX/lib:$LD_LIBRARY_PATH
PIP=$PREFIX/bin/pip3

check $PREFIX/bin/python3 -m ensurepip
check ${PIP} install --upgrade pip

echo "[setuptools]"
check ${PIP} install setuptools wheel

echo "[numpy]"
check ${PIP} install intel-numpy

echo "[scipy]"
check ${PIP} install intel-scipy

echo "[matplotlib]"
check ${PIP} install matplotlib
# echo "change backend of matplotlib to Agg"
# sed -i 's/backend\s*:\s*TkAgg/backend : Agg/' $PREFIX/lib/python$PVERSION/site-packages/matplotlib/mpl-data/matplotlibrc

echo "[jupyter]" 
check ${PIP} install sphinx jupyter

echo "[mock]"
check ${PIP} install mock

echo "[toml]"
check ${PIP} install toml

echo "[Cython]"
check ${PIP} install Cython

echo "[mpi4py]"
check ${PIP} install mpi4py

echo "[mako]"
check ${PIP} install mako
