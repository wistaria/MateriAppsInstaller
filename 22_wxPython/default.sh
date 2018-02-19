#!/bin/sh

SCRIPT_DIR=$(cd "$(dirname $0)"; pwd)
. $SCRIPT_DIR/../util.sh
set_prefix
. $PREFIX_TOOL/env.sh
. $SCRIPT_DIR/version.sh


LOG=$BUILD_DIR/wxpython-$PYTHON_VERSION-$PYTHON_MA_REVISION.log
PYPREFIX=$PREFIX_TOOL/python/python-$PYTHON_VERSION-$PYTHON_MA_REVISION
export LD_LIBRARY_PATH=$PYPREFIX/lib:$LD_LIBRARY_PATH

# sh $SCRIPT_DIR/setup.sh
rm -rf $LOG

echo "[wxPython]" | tee -a $LOG
cd $BUILD_DIR/wxPython-src-$WX_VERSION/wxPython
check env LD_LIBRARY_PATH=$PYPREFIX/lib:$LD_LIBRARY_PATH $PYPREFIX/bin/python setup.py build WXPORT="gtk2" | tee -a $LOG
env LD_LIBRARY_PATH=$PYPREFIX/lib:$LD_LIBRARY_PATH $PYPREFIX/bin/python setup.py install WXPORT="gtk2" | tee -a $LOG

echo "[PyOpenGL]" | tee -a $LOG
cd $BUILD_DIR/PyOpenGL-$PYOPENGL_VERSION
check env LD_LIBRARY_PATH=$PYPREFIX/lib:$LD_LIBRARY_PATH $PYPREFIX/bin/python setup.py build | tee -a $LOG
env LD_LIBRARY_PATH=$PYPREFIX/lib:$LD_LIBRARY_PATH $PYPREFIX/bin/python setup.py install | tee -a $LOG
