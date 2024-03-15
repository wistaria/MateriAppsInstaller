python3 -m pip install --prefix=$PREFIX ./

if [ -d ${PREFIX}/local ]; then
  PREFIX=${PREFIX}/local
fi

cp -r examples $PREFIX
