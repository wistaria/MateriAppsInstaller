mkdir -p $PREFIX/bin
cd bin
for exe in $(ls -1); do
  cp $exe $PREFIX/bin
  kind=$(echo $exe | cut -d- -f1)
  compiler=$(echo $exe | cut -d- -f3)
  ln -s $PREFIX/bin/$exe $PREFIX/bin/${kind}-${compiler}
done
