#!/bin/sh

SCRIPT_DIR=$(cd "$(dirname $0)"; pwd)
. $SCRIPT_DIR/../util.sh
set_prefix
. $PREFIX_TOOL/env.sh
. $SCRIPT_DIR/version.sh

$SUDO_TOOL /bin/true
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
check ./configure --prefix=$PREFIX --enable-shared | tee -a $LOG
check make -j4 | tee -a $LOG
$SUDO_TOOL make install

echo "[pip]" | tee -a $LOG
cd $BUILD_DIR
$SUDO_TOOL env LD_LIBRARY_PATH=$PREFIX/lib:$LD_LIBRARY_PATH $PREFIX/bin/python get-pip.py | tee -a $LOG

echo "[numpy]" | tee -a $LOG
cd $BUILD_DIR/numpy-$NUMPY_VERSION
check patch -p1 < $SCRIPT_DIR/numpy-$NUMPY_VERSION.patch
cat << EOF > site.cfg
[mkl]
library_dirs = $(echo $MKLROOT | cut -d : -f 1)/lib/intel64
include_dirs = $(echo $MKLROOT | cut -d : -f 1)/include
mkl_libs = mkl_rt
lapack_libs =
EOF
check env LD_LIBRARY_PATH=$PREFIX/lib:$LD_LIBRARY_PATH $PREFIX/bin/python setup.py config --compiler=intel build_clib --compiler=intel build_ext --compiler=intel | tee -a $LOG
$SUDO_TOOL env LD_LIBRARY_PATH=$PREFIX/lib:$LD_LIBRARY_PATH $PREFIX/bin/python setup.py install | tee -a $LOG

echo "[scipy]" | tee -a $LOG
cd $BUILD_DIR/scipy-$SCIPY_VERSION
check env LD_LIBRARY_PATH=$PREFIX/lib:$LD_LIBRARY_PATH $PREFIX/bin/python setup.py config --compiler=intel --fcompiler=intel build_clib --compiler=intel --fcompiler=intel build_ext --compiler=intel --fcompiler=intel | tee -a $LOG
$SUDO_TOOL env LD_LIBRARY_PATH=$PREFIX/lib:$LD_LIBRARY_PATH $PREFIX/bin/python setup.py install | tee -a $LOG

echo "[matplotlib]" | tee -a $LOG
cd $BUILD_DIR
$SUDO_TOOL env LD_LIBRARY_PATH=$PREFIX/lib:$LD_LIBRARY_PATH $PREFIX/bin/pip install matplotlib | tee -a $LOG

echo "[ipython]" | tee -a $LOG
cd $BUILD_DIR
$SUDO_TOOL env LD_LIBRARY_PATH=$PREFIX/lib:$LD_LIBRARY_PATH $PREFIX/bin/pip install sphinx pyzmq tornado ipython | tee -a $LOG

echo "[mock]" | tee -a $LOG
cd $BUILD_DIR
$SUDO_TOOL env LD_LIBRARY_PATH=$PREFIX/lib:$LD_LIBRARY_PATH $PREFIX/bin/pip install mock | tee -a $LOG

cat << EOF > $BUILD_DIR/pythonvars.sh
# python $(basename $0 .sh) $PYTHON_VERSION $PYTHON_MA_REVISION $(date +%Y%m%d-%H%M%S)
export PYTHON_ROOT=$PREFIX
export PYTHON_VERSION=$PYTHON_VERSION
export PYTHON_MA_REVISION=$PYTHON_MA_REVISION
export PATH=\$PYTHON_ROOT/bin:\$PATH
export LD_LIBRARY_PATH=\$PYTHON_ROOT/lib:\$LD_LIBRARY_PATH
EOF
PYTHONVARS_SH=$PREFIX_TOOL/python/pythonvars-$PYTHON_VERSION-$PYTHON_MA_REVISION.sh
$SUDO_TOOL rm -f $PYTHONVARS_SH
$SUDO_TOOL cp -f $BUILD_DIR/pythonvars.sh $PYTHONVARS_SH
rm -f $BUILD_DIR/pythonvars.sh
$SUDO_TOOL cp -f $LOG $PREFIX_TOOL/python/
