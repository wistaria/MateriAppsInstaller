make install

for exe in idle pydoc python; do
  ln -s ${exe}3 ${PREFIX}/bin/${exe}
done
