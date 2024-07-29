mkdir -p $PREFIX/bin

cp build/alm/alm $PREFIX/bin
cp build/anphon/anphon $PREFIX/bin

mkdir -p $PREFIX/tools
for name in analyze_phonons dfc2 fc_virtual parse_fcsxml qe2alm; do
  cp build/tools/$name $PREFIX/tools
done

cp tools/*.py $PREFIX/tools
cp -r tools/interface $PREFIX/tools

cp -r example $PREFIX

