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

echo "[numpy]" | tee -a $LOG
$PREFIX/bin/pip3 install --install-option="config" --install-option="--compiler=intelem build_clib" --install-option="--compiler=intelem build_ext" --install-option="--compiler=intelem" numpy 2>&1 | tee -a $LOG

echo "[scipy]" | tee -a $LOG
$PREFIX/bin/pip3 install --install-option="config" --install-option="--compiler=intelem" --install-option="--fcompiler=intelem build_clib" --install-option="--compiler=intelem" --install-option="--fcompiler=intelem build_ext" --install-option="--compiler=intelem" --install-option="--fcompiler=intelem" scipy 2>&1 | tee -a $LOG

echo "[matplotlib]" | tee -a $LOG
$PREFIX/bin/pip3 install matplotlib | tee -a $LOG
# echo "change backend of matplotlib to Agg" | tee -a $LOG
# sed -i 's/backend\s*:\s*TkAgg/backend : Agg/' $PREFIX/lib/python$PVERSION/site-packages/matplotlib/mpl-data/matplotlibrc

echo "[jupyter]" | tee -a $LOG
$PREFIX/bin/pip3 install sphinx jupyter | tee -a $LOG

echo "[mock]" | tee -a $LOG
$PREFIX/bin/pip3 install mock | tee -a $LOG

echo "[toml]" | tee -a $LOG
$PREFIX/bin/pip3 install toml | tee -a $LOG
