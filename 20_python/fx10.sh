#!/bin/sh

SCRIPT_DIR=$(cd "$(dirname $0)"; pwd)
. $SCRIPT_DIR/../util.sh
set_prefix
. $PREFIX_TOOL/env.sh
. $SCRIPT_DIR/version.sh

$SUDO_TOOL /bin/true
LOG=$BUILD_DIR/python-$PYTHON_VERSION-$PYTHON_MA_REVISION.log
PREFIX=$PREFIX_TOOL/python/python-$PYTHON_VERSION-$PYTHON_MA_REVISION
PREFIX_FRONTEND="$PREFIX/Linux-x86_64"
export LD_LIBRARY_PATH=$PREFIX_FRONTEND/lib:$LD_LIBRARY_PATH

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
check ./configure --prefix=$PREFIX_FRONTEND --enable-shared | tee -a $LOG
check make -j4 | tee -a $LOG
$SUDO_TOOL make install

echo "[pip]" | tee -a $LOG
cd $BUILD_DIR/Python-$PYTHON_VERSION
$SUDO_TOOL env LD_LIBRARY_PATH=$PREFIX_FRONTEND/lib:$LD_LIBRARY_PATH $PREFIX_FRONTEND/bin/python get-pip.py | tee -a $LOG
$SUDO_TOOL env LD_LIBRARY_PATH=$PREFIX_FRONTEND/lib:$LD_LIBRARY_PATH $PREFIX_FRONTEND/bin/pip install --upgrade pip

echo "[numpy]" | tee -a $LOG
cd $BUILD_DIR/Python-$PYTHON_VERSION/numpy-$NUMPY_VERSION
cat << EOF > site.cfg
[DEFAULT]
library_dirs = $LAPACK_ROOT/Linux-x86_64/lib
EOF
check env LD_LIBRARY_PATH=$PREFIX_FRONTEND/lib:$LD_LIBRARY_PATH $PREFIX_FRONTEND/bin/python setup.py build --fcompiler=gnu95 | tee -a $LOG
$SUDO_TOOL env LD_LIBRARY_PATH=$PREFIX_FRONTEND/lib:$LD_LIBRARY_PATH $PREFIX_FRONTEND/bin/python setup.py install | tee -a $LOG

echo "[scipy]" | tee -a $LOG
cd $BUILD_DIR/Python-$PYTHON_VERSION/scipy-$SCIPY_VERSION
check env LD_LIBRARY_PATH=$PREFIX_FRONTEND/lib:$LD_LIBRARY_PATH $PREFIX_FRONTEND/bin/python setup.py build --fcompiler=gnu95 | tee -a $LOG
$SUDO_TOOL env LD_LIBRARY_PATH=$PREFIX_FRONTEND/lib:$LD_LIBRARY_PATH $PREFIX_FRONTEND/bin/python setup.py install | tee -a $LOG

echo "[matplotlib]" | tee -a $LOG
$SUDO_TOOL env LD_LIBRARY_PATH=$PREFIX_FRONTEND/lib:$LD_LIBRARY_PATH $PREFIX_FRONTEND/bin/pip install matplotlib | tee -a $LOG

echo "[ipython]" | tee -a $LOG
$SUDO_TOOL env LD_LIBRARY_PATH=$PREFIX_FRONTEND/lib:$LD_LIBRARY_PATH $PREFIX_FRONTEND/bin/pip install sphinx pyzmq tornado ipython | tee -a $LOG

echo "[virtualenv]" | tee -a $LOG
$SUDO_TOOL env LD_LIBRARY_PATH=$PREFIX_FRONTEND/lib:$LD_LIBRARY_PATH $PREFIX_FRONTEND/bin/pip install virtualenv | tee -a $LOG

echo "[mock]" | tee -a $LOG
$SUDO_TOOL env LD_LIBRARY_PATH=$PREFIX_FRONTEND/lib:$LD_LIBRARY_PATH $PREFIX_FRONTEND/bin/pip install mock | tee -a $LOG

cat << EOF > $BUILD_DIR/pythonvars.sh
# python $(basename $0 .sh) $PYTHON_VERSION $PYTHON_MA_REVISION $(date +%Y%m%d-%H%M%S)
OS=\$(uname -s)
ARCH=\$(uname -m)
export PYTHON_ROOT=$PREFIX
export PYTHON_VERSION=$PYTHON_VERSION
export PYTHON_MA_REVISION=$PYTHON_MA_REVISION
export PATH=\$PYTHON_ROOT/\$OS-\$ARCH/bin:\$PATH
export LD_LIBRARY_PATH=\$PYTHON_ROOT/\$OS-\$ARCH/lib:\$LD_LIBRARY_PATH
EOF
PYTHONVARS_SH=$PREFIX_TOOL/python/pythonvars-$PYTHON_VERSION-$PYTHON_MA_REVISION.sh
$SUDO_TOOL rm -f $PYTHONVARS_SH
$SUDO_TOOL cp -f $BUILD_DIR/pythonvars.sh $PYTHONVARS_SH
rm -f $BUILD_DIR/pythonvars.sh
$SUDO_TOOL cp -f $LOG $PREFIX_TOOL/python/
