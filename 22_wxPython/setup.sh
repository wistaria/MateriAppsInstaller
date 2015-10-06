#!/bin/sh

SCRIPT_DIR=$(cd "$(dirname $0)"; pwd)
. $SCRIPT_DIR/../util.sh
set_prefix
. $PREFIX_TOOL/env.sh
. $SCRIPT_DIR/version.sh

cd $BUILD_DIR

# wxPython
# if [ -d wxPython-$WX_VERSION ]; then :; else
#   if [ -f $HOME/source/wxPython-src-$WX_VERSION.tar.bz2 ]; then
#     check tar jxf $HOME/source/wxPython-src-${WX_VERSION}.tar.bz2
#   else
#     check wget http://sourceforge.net/projects/wxpython/files/wxPython/$WX_VERSION/wxPython-src-${WX_VERSION}.tar.bz2 -O $HOME/source/wxPython-src-${WX_VERSION}.tar.bz2
#     check tar jxf $HOME/source/wxPython-src-${WX_VERSION}.tar.bz2
#   fi
# fi

# PyOpenGL
if [ -d PyOpenGL-$PYOPENGL_VERSION ]; then :; else
  if [ -f $HOME/source/PyOpenGL-$PYOPENGL_VERSION.tar.bz2 ]; then
    check tar zxf $HOME/source/PyOpenGL-$PYOPENGL_VERSION.tar.gz
  else
    check wget https://pypi.python.org/packages/source/P/PyOpenGL/PyOpenGL-$PYOPENGL_VERSION.tar.gz -O $HOME/source/PyOpenGL-$PYOPENGL_VERSION.tar.gz
    check tar zxf $HOME/source/PyOpenGL-$PYOPENGL_VERSION.tar.gz
  fi
fi
