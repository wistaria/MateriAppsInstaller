. $UTIL_SH

export LD_LIBRARY_PATH=$PREFIX/lib:$LD_LIBRARY_PATH
PIP=$PREFIX/bin/pip3

check $PREFIX/bin/python3 -m ensurepip
check ${PIP} install --upgrade pip

echo "[setuptools]"
check ${PIP} install setuptools wheel

rm -f numpy-site.cfg.org
if [ -e ~/numpy-site.cfg ]; then
  cp ~/numpy-site.cfg ./numpy-site.cfg.org
fi
cat << EOF > ~/numpy-site.cfg
[mkl]
library_dirs = $(echo $MKLROOT | cut -d: -f1)/lib/intel64
include_dirs = $(echo $MKLROOT | cut -d: -f1)/include
mkl_libs = mkl_rt
lapack_libs = 
EOF

echo "[numpy]"
check ${PIP} install --install-option="config" --install-option="--compiler=intelem build_clib" --install-option="--compiler=intelem build_ext" --install-option="--compiler=intelem" numpy

echo "[scipy]"
check ${PIP} install --install-option="config" --install-option="--compiler=intelem" --install-option="--fcompiler=intelem build_clib" --install-option="--compiler=intelem" --install-option="--fcompiler=intelem build_ext" --install-option="--compiler=intelem" --install-option="--fcompiler=intelem" scipy

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
