echo "[matplotlib]" | tee -a $LOG
$PREFIX/bin/pip3 install matplotlib | tee -a $LOG
echo "change backend of matplotlib to Agg" | tee -a $LOG
sed -i 's/backend\s*:\s*TkAgg/backend : Agg/' $PREFIX/lib/python$PVERSION/site-packages/matplotlib/mpl-data/matplotlibrc

echo "[jupyter]" | tee -a $LOG
$PREFIX/bin/pip3 install sphinx jupyter | tee -a $LOG

echo "[mock]" | tee -a $LOG
$PREFIX/bin/pip3 install mock | tee -a $LOG

echo "[toml]" | tee -a $LOG
$PREFIX/bin/pip3 install toml | tee -a $LOG
