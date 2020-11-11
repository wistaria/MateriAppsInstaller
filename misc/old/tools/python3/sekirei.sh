#!/bin/sh

SCRIPT_DIR=$(cd "$(dirname $0)"; pwd)
. $SCRIPT_DIR/../util.sh
set_prefix
. $PREFIX_TOOL/env.sh
. $SCRIPT_DIR/version.sh

LOG=$BUILD_DIR/python3-$PYTHON3_VERSION-$PYTHON3_MA_REVISION.log
PREFIX=$PREFIX_TOOL/python3/python3-$PYTHON3_VERSION-$PYTHON3_MA_REVISION
export LD_LIBRARY_PATH=$PREFIX/lib:$LD_LIBRARY_PATH

if [ -d $PREFIX ]; then
  echo "Error: $PREFIX exists"
  exit 127
fi

sh $SCRIPT_DIR/setup.sh
rm -rf $LOG

echo "[python3]" | tee -a $LOG
cd $BUILD_DIR/Python-$PYTHON3_VERSION
check env CFLAGS="-I/opt/suse/include -I/usr/include/ncurses" env LDFLAGS="-L/opt/suse/lib64" ./configure --prefix=$PREFIX --with-libs='-lssl' --enable-shared --with-icc | tee -a $LOG
check make | tee -a $LOG
make install

PVERSION=$($PREFIX/bin/python3 --version | cut -d' ' -f2 | cut -d. -f1,2)

echo "[pip]" | tee -a $LOG
$PREFIX/bin/pip3 install -U pip | tee -a $LOG

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
$PREFIX/bin/pip3 install --install-option="config" --install-option="--compiler=intelem build_clib" --install-option="--compiler=intelem build_ext" --install-option="--compiler=intelem" numpy | tee -a $LOG

echo "[scipy]" | tee -a $LOG
$PREFIX/bin/pip3 install --install-option="config" --install-option="--compiler=intelem" --install-option="--fcompiler=intelem build_clib" --install-option="--compiler=intelem" --install-option="--fcompiler=intelem build_ext" --install-option="--compiler=intelem" --install-option="--fcompiler=intelem" scipy | tee -a $LOG

echo "[matplotlib]" | tee -a $LOG
$PREFIX/bin/pip3 install matplotlib | tee -a $LOG
echo "change backend of matplotlib to Agg" | tee -a $LOG
sed -i 's/backend\s*:\s*TkAgg/backend : Agg/' $PREFIX/lib/python$PVERSION/site-packages/matplotlib/mpl-data/matplotlibrc

echo "[jupyter]" | tee -a $LOG
$PREFIX/bin/pip3 install sphinx jupyter | tee -a $LOG

echo "[mock]" | tee -a $LOG
$PREFIX/bin/pip3 install mock | tee -a $LOG

cat << EOF > $BUILD_DIR/python3vars.sh
# python3 $(basename $0 .sh) $PYTHON3_VERSION $PYTHON3_MA_REVISION $(date +%Y%m%d-%H%M%S)
export PYTHON3_ROOT=$PREFIX
export PYTHON3_VERSION=$PYTHON3_VERSION
export PYTHON3_MA_REVISION=$PYTHON3_MA_REVISION
export PATH=\$PYTHON3_ROOT/bin:\$PATH
export LD_LIBRARY_PATH=\$PYTHON3_ROOT/lib:\$LD_LIBRARY_PATH
EOF
PYTHON3VARS_SH=$PREFIX_TOOL/python3/python3vars-$PYTHON3_VERSION-$PYTHON3_MA_REVISION.sh
rm -f $PYTHON3VARS_SH
cp -f $BUILD_DIR/python3vars.sh $PYTHON3VARS_SH
rm -f $BUILD_DIR/python3vars.sh
cp -f $LOG $PREFIX_TOOL/python3/
