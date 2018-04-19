#!/bin/sh

SCRIPT_DIR=$(cd "$(dirname $0)"; pwd)
. $SCRIPT_DIR/../util.sh
set_prefix
. $PREFIX_TOOL/env.sh
. $SCRIPT_DIR/version.sh

LOG=$BUILD_DIR/python-$PYTHON_VERSION-$PYTHON_MA_REVISION.log
PREFIX=$PREFIX_TOOL/python/python-$PYTHON_VERSION-$PYTHON_MA_REVISION
export LD_LIBRARY_PATH=$PREFIX/lib:$LD_LIBRARY_PATH

if [ -d $PREFIX ]; then
  echo "Error: $PREFIX exists"
  exit 127
fi

sh $SCRIPT_DIR/setup.sh
rm -rf $LOG

if [ -d $SOURCE_DIR/python ]; then
  export PIP_NO_INDEX=true
  export PIP_FIND_LINKS=$SOURCE_DIR/python
fi

echo "[python]" | tee -a $LOG
cd $BUILD_DIR/Python-$PYTHON_VERSION
check env CFLAGS="-I/opt/suse/include -I/usr/include/ncurses" ./configure --prefix=$PREFIX --enable-shared --with-libs='/opt/suse/lib64/libssl.so' | tee -a $LOG
check make | tee -a $LOG
make install

PVERSION=$($PREFIX/bin/python --version 2>&1 | awk '{print $2}' | cut -d. -f1,2)

echo "[pip]" | tee -a $LOG
cd $BUILD_DIR/Python-$PYTHON_VERSION
$PREFIX/bin/python get-pip.py | tee -a $LOG
$PREFIX/bin/pip install --upgrade pip

rm -f numpy-site.cfg.org
if [ -e ~/numpy-site.cfg ]; then
  cp ~/numpy-site.cfg ./numpy-site.cfg.org
fi

cat <<EOF > numpy-site.cfg
[mkl]
library_dirs = $(echo $MKL_ROOT | cut -d: -f1)/lib/intel64
include_dirs = $(echo $MKL_ROOT | cut -d: -f1)/include
mkl_libs = mkl_rt
lapack_libs = 
EOF
cp numpy-site.cfg ~/numpy-site.cfg


echo "[numpy]" | tee -a $LOG
check $PREFIX/bin/pip install --install-option="config" --install-option="--compiler=intelem build_clib" --install-option="--compiler=intelem build_ext" --install-option="--compiler=intelem" numpy | tee -a $LOG

echo "[scipy]" | tee -a $LOG
check $PREFIX/bin/pip install --install-option="config" --install-option="--compiler=intelem" --install-option="--fcompiler=intelem build_clib" --install-option="--compiler=intelem" --install-option="--fcompiler=intelem build_ext" --install-option="--compiler=intelem" --install-option="--fcompiler=intelem" scipy | tee -a $LOG

if [ -e numpy-site.cfg.org ] ;then
  cp numpy-site.cfg.org ~/numpy-site.cfg
else
  rm ~/numpy-site.cfg
fi

echo "[matplotlib]" | tee -a $LOG
env LD_LIBRARY_PATH=$PREFIX/lib:$LD_LIBRARY_PATH $PREFIX/bin/pip install matplotlib | tee -a $LOG
echo "change backend of matplotlib to Agg" | tee -a $LOG
sed -i 's/backend\s*:\s*TkAgg/backend : Agg/' $PREFIX/lib/python$PVERSION/site-packages/matplotlib/mpl-data/matplotlibrc

echo "[jupyter]" | tee -a $LOG
$PREFIX/bin/pip install sphinx jupyter | tee -a $LOG

echo "[virtualenv]" | tee -a $LOG
$PREFIX/bin/pip install virtualenv | tee -a $LOG


echo "[mock]" | tee -a $LOG
env LD_LIBRARY_PATH=$PREFIX/lib:$LD_LIBRARY_PATH $PREFIX/bin/pip install mock | tee -a $LOG

cat << EOF > $BUILD_DIR/pythonvars.sh
# python $(basename $0 .sh) $PYTHON_VERSION $PYTHON_MA_REVISION $(date +%Y%m%d-%H%M%S)
export PYTHON_ROOT=$PREFIX
export PYTHON_VERSION=$PYTHON_VERSION
export PYTHON_MA_REVISION=$PYTHON_MA_REVISION
export PATH=\$PYTHON_ROOT/bin:\$PATH
export LD_LIBRARY_PATH=\$PYTHON_ROOT/lib:\$LD_LIBRARY_PATH
EOF
PYTHONVARS_SH=$PREFIX_TOOL/python/pythonvars-$PYTHON_VERSION-$PYTHON_MA_REVISION.sh
rm -f $PYTHONVARS_SH
cp -f $BUILD_DIR/pythonvars.sh $PYTHONVARS_SH
rm -f $BUILD_DIR/pythonvars.sh
cp -f $LOG $PREFIX_TOOL/python/
