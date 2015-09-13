#!/bin/sh

SCRIPT_DIR=$(cd "$(dirname $0)"; pwd)
. $SCRIPT_DIR/../util.sh
set_prefix
. $PREFIX_TOOL/env.sh
. $SCRIPT_DIR/version.sh

$SUDO_TOOL /bin/true
LOG=$BUILD_DIR/wxpython-$PYTHON_VERSION-$PYTHON_MA_REVISION.log
PYPREFIX=$PREFIX_TOOL/python/python-$PYTHON_VERSION-$PYTHON_MA_REVISION
PREFIX=$PREFIX_TOOL/wxpython/python-$PYTHON_VERSION-$PYTHON_MA_REVISION
export LD_LIBRARY_PATH=$PREFIX/lib:$PYPREFIX/lib:$LD_LIBRARY_PATH

if [ -d $PREFIX ]; then
  echo "Error: $PREFIX exists"
  exit 127
fi

# sh $SCRIPT_DIR/setup.sh
rm -rf $LOG

echo "[wxPython]" | tee -a $LOG
cd $BUILD_DIR/wxPython-src-$WX_VERSION/wxPython
check env LD_LIBRARY_PATH=$PREFIX/lib:$LD_LIBRARY_PATH $PYPREFIX/bin/python setup.py build WXPORT="gtk2" | tee -a $LOG
$SUDO_TOOL env LD_LIBRARY_PATH=$PREFIX/lib:$LD_LIBRARY_PATH $PYPREFIX/bin/python setup.py install WXPORT="gtk2" | tee -a $LOG

echo "[PyOpenGL]" | tee -a $LOG
cd $BUILD_DIR/PyOpenGL-$PYOPENGL_VERSION
check env LD_LIBRARY_PATH=$PREFIX/lib:$LD_LIBRARY_PATH $PYPREFIX/bin/python setup.py build | tee -a $LOG
$SUDO_TOOL env LD_LIBRARY_PATH=$PREFIX/lib:$LD_LIBRARY_PATH $PYPREFIX/bin/python setup.py install | tee -a $LOG



# cat << EOF > $BUILD_DIR/pythonvars.sh
# # python $(basename $0 .sh) $PYTHON_VERSION $PYTHON_MA_REVISION $(date +%Y%m%d-%H%M%S)
# export PYTHON_ROOT=$PREFIX
# export PYTHON_VERSION=$PYTHON_VERSION
# export PYTHON_MA_REVISION=$PYTHON_MA_REVISION
# export PATH=\$PYTHON_ROOT/bin:\$PATH
# export LD_LIBRARY_PATH=\$PYTHON_ROOT/lib:\$LD_LIBRARY_PATH
# EOF
# PYTHONVARS_SH=$PREFIX_TOOL/python/pythonvars-$PYTHON_VERSION-$PYTHON_MA_REVISION.sh
# $SUDO_TOOL rm -f $PYTHONVARS_SH
# $SUDO_TOOL cp -f $BUILD_DIR/pythonvars.sh $PYTHONVARS_SH
# rm -f $BUILD_DIR/pythonvars.sh
# $SUDO_TOOL cp -f $LOG $PREFIX_TOOL/python/
