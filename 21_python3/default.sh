#!/bin/sh

SCRIPT_DIR=$(cd "$(dirname $0)"; pwd)
. $SCRIPT_DIR/../util.sh
set_prefix
. $PREFIX_TOOL/env.sh
. $SCRIPT_DIR/version.sh

$SUDO_TOOL /bin/true
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
check ./configure --prefix=$PREFIX --enable-shared | tee -a $LOG
check make -j4 | tee -a $LOG
$SUDO_TOOL make install

echo "[numpy]" | tee -a $LOG
cd $BUILD_DIR/Python-$PYTHON3_VERSION/numpy-$NUMPY_VERSION
check env LD_LIBRARY_PATH=$PREFIX/lib:$LD_LIBRARY_PATH $PREFIX/bin/python3 setup.py build | tee -a $LOG
$SUDO_TOOL env LD_LIBRARY_PATH=$PREFIX/lib:$LD_LIBRARY_PATH $PREFIX/bin/python3 setup.py install | tee -a $LOG

echo "[scipy]" | tee -a $LOG
cd $BUILD_DIR/Python-$PYTHON3_VERSION/scipy-$SCIPY_VERSION
check env LD_LIBRARY_PATH=$PREFIX/lib:$LD_LIBRARY_PATH $PREFIX/bin/python3 setup.py build | tee -a $LOG
$SUDO_TOOL env LD_LIBRARY_PATH=$PREFIX/lib:$LD_LIBRARY_PATH $PREFIX/bin/python3 setup.py install | tee -a $LOG

echo "[matplotlib]" | tee -a $LOG
$SUDO_TOOL env LD_LIBRARY_PATH=$PREFIX/lib:$LD_LIBRARY_PATH $PREFIX/bin/pip3 install matplotlib | tee -a $LOG

echo "[jupyter]" | tee -a $LOG
$SUDO_TOOL env LD_LIBRARY_PATH=$PREFIX/lib:$LD_LIBRARY_PATH $PREFIX/bin/pip3 install sphinx jupyter | tee -a $LOG

echo "[mock]" | tee -a $LOG
$SUDO_TOOL env LD_LIBRARY_PATH=$PREFIX/lib:$LD_LIBRARY_PATH $PREFIX/bin/pip3 install mock | tee -a $LOG

cat << EOF > $BUILD_DIR/python3vars.sh
# python3 $(basename $0 .sh) $PYTHON3_VERSION $PYTHON3_MA_REVISION $(date +%Y%m%d-%H%M%S)
export PYTHON3_ROOT=$PREFIX
export PYTHON3_VERSION=$PYTHON3_VERSION
export PYTHON3_MA_REVISION=$PYTHON3_MA_REVISION
export PATH=\$PYTHON3_ROOT/bin:\$PATH
export LD_LIBRARY_PATH=\$PYTHON3_ROOT/lib:\$LD_LIBRARY_PATH
EOF
PYTHON3VARS_SH=$PREFIX_TOOL/python3/python3vars-$PYTHON3_VERSION-$PYTHON3_MA_REVISION.sh
$SUDO_TOOL rm -f $PYTHON3VARS_SH
$SUDO_TOOL cp -f $BUILD_DIR/python3vars.sh $PYTHON3VARS_SH
rm -f $BUILD_DIR/python3vars.sh
$SUDO_TOOL cp -f $LOG $PREFIX_TOOL/python3/
