#!/bin/sh

SCRIPT_DIR=$(cd "$(dirname $0)"; pwd)
. $SCRIPT_DIR/../util.sh
. $SCRIPT_DIR/version.sh
set_prefix

$SUDO_TOOL /bin/true
. $PREFIX_TOOL/env.sh
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

echo "[python]" | tee -a $LOG
cd $BUILD_DIR/Python-$PYTHON_VERSION
check ./configure --prefix=$PREFIX_FRONTEND --enable-shared | tee -a $LOG
check make -j4 | tee -a $LOG
$SUDO_TOOL make install

echo "[nose]" | tee -a $LOG
cd $BUILD_DIR/nose-$NOSE_VERSION
check $PREFIX_FRONTEND/bin/python setup.py build | tee -a $LOG
$SUDO_TOOL env LD_LIBRARY_PATH=$PREFIX_FRONTEND/lib:$LD_LIBRARY_PATH $PREFIX_FRONTEND/bin/python setup.py install | tee -a $LOG

echo "[distribute]" | tee -a $LOG
cd $BUILD_DIR/distribute-$DISTRIBUTE_VERSION
check $PREFIX_FRONTEND/bin/python setup.py build | tee -a $LOG
$SUDO_TOOL env LD_LIBRARY_PATH=$PREFIX_FRONTEND/lib:$LD_LIBRARY_PATH $PREFIX_FRONTEND/bin/python setup.py install | tee -a $LOG

echo "[mock]" | tee -a $LOG
cd $BUILD_DIR/mock-$MOCK_VERSION
check $PREFIX_FRONTEND/bin/python setup.py build | tee -a $LOG
$SUDO_TOOL env LD_LIBRARY_PATH=$PREFIX_FRONTEND/lib:$LD_LIBRARY_PATH $PREFIX_FRONTEND/bin/python setup.py install | tee -a $LOG

echo "[pyparsing]" | tee -a $LOG
cd $BUILD_DIR/pyparsing-$PYPARSING_VERSION
check $PREFIX_FRONTEND/bin/python setup.py build | tee -a $LOG
$SUDO_TOOL env LD_LIBRARY_PATH=$PREFIX_FRONTEND/lib:$LD_LIBRARY_PATH $PREFIX_FRONTEND/bin/python setup.py install | tee -a $LOG

echo "[pytz]" | tee -a $LOG
cd $BUILD_DIR/pytz-$PYTZ_VERSION
check $PREFIX_FRONTEND/bin/python setup.py build | tee -a $LOG
$SUDO_TOOL env LD_LIBRARY_PATH=$PREFIX_FRONTEND/lib:$LD_LIBRARY_PATH $PREFIX_FRONTEND/bin/python setup.py install | tee -a $LOG

echo "[python-dateutil]" | tee -a $LOG
cd $BUILD_DIR/python-dateutil-$PYTHON_DATEUTIL_VERSION
check $PREFIX_FRONTEND/bin/python setup.py build | tee -a $LOG
$SUDO_TOOL env LD_LIBRARY_PATH=$PREFIX_FRONTEND/lib:$LD_LIBRARY_PATH $PREFIX_FRONTEND/bin/python setup.py install | tee -a $LOG

echo "[six]" | tee -a $LOG
cd $BUILD_DIR/six-$SIX_VERSION
check $PREFIX_FRONTEND/bin/python setup.py build | tee -a $LOG
$SUDO_TOOL env LD_LIBRARY_PATH=$PREFIX_FRONTEND/lib:$LD_LIBRARY_PATH $PREFIX_FRONTEND/bin/python setup.py install | tee -a $LOG

echo "[numpy]" | tee -a $LOG
cd $BUILD_DIR/numpy-$NUMPY_VERSION
cat << EOF > site.cfg
[DEFAULT]
library_dirs = $LAPACK_ROOT/Linux-x86_64/lib
EOF
check $PREFIX_FRONTEND/bin/python setup.py build --fcompiler=gnu95 | tee -a $LOG
$SUDO_TOOL env LD_LIBRARY_PATH=$PREFIX_FRONTEND/lib:$LD_LIBRARY_PATH $PREFIX_FRONTEND/bin/python setup.py install | tee -a $LOG

echo "[scipy]" | tee -a $LOG
cd $BUILD_DIR/scipy-$SCIPY_VERSION
check $PREFIX_FRONTEND/bin/python setup.py build --fcompiler=gnu95 | tee -a $LOG
$SUDO_TOOL env LD_LIBRARY_PATH=$PREFIX_FRONTEND/lib:$LD_LIBRARY_PATH $PREFIX_FRONTEND/bin/python setup.py install | tee -a $LOG

echo "[matplotlib]" | tee -a $LOG
cd $BUILD_DIR/matplotlib-$MATPLOTLIB_VERSION
check $PREFIX_FRONTEND/bin/python setup.py build | tee -a $LOG
$SUDO_TOOL env LD_LIBRARY_PATH=$PREFIX_FRONTEND/lib:$LD_LIBRARY_PATH $PREFIX_FRONTEND/bin/python setup.py install | tee -a $LOG

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
