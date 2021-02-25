rm -f numpy-site.cfg.org
if [ -e ~/numpy-site.cfg ]; then
  cp ~/numpy-site.cfg ./numpy-site.cfg.org
fi

cat <<EOF > numpy-site.cfg
[mkl]
library_dirs = $(echo $MKLROOT | cut -d: -f1)/lib/intel64
include_dirs = $(echo $MKLROOT | cut -d: -f1)/include
mkl_libs = mkl_rt
lapack_libs = 
EOF

cp numpy-site.cfg ~/numpy-site.cfg

echo "[pip]"
$PREFIX/bin/python3 -m ensurepip
$PREFIX/bin/python3 -m pip -U pip

echo "[setuptools]"
$PREFIX/bin/pip3 install sphinx setuptools wheel

echo "[Cython]"
$PREFIX/bin/pip3 install Cython

echo "[numpy]"
$PREFIX/bin/pip3 install --install-option="config" --install-option="--compiler=intelem build_clib" --install-option="--compiler=intelem build_ext" --install-option="--compiler=intelem" numpy

echo "[scipy]"
$PREFIX/bin/pip3 install --install-option="config" --install-option="--compiler=intelem" --install-option="--fcompiler=intelem build_clib" --install-option="--compiler=intelem" --install-option="--fcompiler=intelem build_ext" --install-option="--compiler=intelem" --install-option="--fcompiler=intelem" scipy

echo "[matplotlib]"
$PREFIX/bin/pip3 install matplotlib
# echo "change backend of matplotlib to Agg" | tee -a $LOG
# sed -i 's/backend\s*:\s*TkAgg/backend : Agg/' $PREFIX/lib/python$PVERSION/site-packages/matplotlib/mpl-data/matplotlibrc

echo "[jupyter]" 
$PREFIX/bin/pip3 install sphinx jupyter

echo "[mock]"
$PREFIX/bin/pip3 install mock

echo "[toml]"
$PREFIX/bin/pip3 install toml

echo "[mpi4py]"
$PREFIX/bin/pip3 install mpi4py
