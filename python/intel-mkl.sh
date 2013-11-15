#!/bin/sh

SCRIPT_DIR=`dirname $0`
. $SCRIPT_DIR/../util.sh
. $SCRIPT_DIR/version.sh
set_prefix
set_build_dir

cd $BUILDDIR
rm -rf Python-$PYTHON_VERSION
if [ -f $HOME/source/Python-$PYTHON_VERSION.tar.bz2 ]; then
  check tar jxf $HOME/source/Python-$PYTHON_VERSION.tar.bz2
else
  check wget -O - http://www.python.org/ftp/python/$PYTHON_VERSION/Python-$PYTHON_VERSION.tar.bz2 | tar jxf -
fi
cd Python-$PYTHON_VERSION
check ./configure --prefix=$PREFIX_OPT --enable-shared
check make -j4
check sudo make install

cd $BUILDDIR
rm -rf nose-$NOSE_VERSION
if [ -f $HOME/source/nose-$NOSE_VERSION.tar.gz ]; then
  check tar zxf $HOME/source/nose-$NOSE_VERSION.tar.gz
else
  check wget http://pypi.python.org/packages/source/n/nose/nose-$NOSE_VERSION.tar.gz | tar zxf -
fi
cd nose-$NOSE_VERSION
LD_LIBRARY_PATH=$PREFIX_OPT/lib:$LD_LIBRARY_PATH check $PREFIX_OPT/bin/python2.7 setup.py build
check sudo LD_LIBRARY_PATH=$PREFIX_OPT/lib:$LD_LIBRARY_PATH $PREFIX_OPT/bin/python2.7 setup.py install

cd $BUILDDIR
rm -rf numpy-$NUMPY_VERSION
if [ -f$HOME/source/numpy-$NUMPY_VERSION.tar.gz ]; then
  check tar zxf $HOME/source/numpy-$NUMPY_VERSION.tar.gz
else
  check wget -O - http://sourceforge.net/projects/numpy/files/NumPy/$NUMPY_VERSION/numpy-$NUMPY_VERSION.tar.gz/download numpy-$NUMPY_VERSION.tar.gz | tar zxf -
fi
cd numpy-$NUMPY_VERSION
check patch -p1 < $SCRIPT_DIR/numpy-$NUMPY_VERSION.patch
cat << EOF > site.cfg
[mkl]
library_dirs = /home/issp/intel/mkl/lib/intel64
include_dirs = /home/issp/intel/mkl/include
mkl_libs = mkl_rt
lapack_libs =
EOF
LD_LIBRARY_PATH=$PREFIX_OPT/lib:$LD_LIBRARY_PATH check $PREFIX_OPT/bin/python2.7 setup.py config --compiler=intel build_clib --compiler=intel build_ext --compiler=intel
check sudo LD_LIBRARY_PATH=$PREFIX_OPT/lib:$LD_LIBRARY_PATH $PREFIX_OPT/bin/python2.7 setup.py install

cd $BUILDDIR
rm -rf scipy-$SCIPY_VERSION
if [ -f $HOME/source/scipy-$SCIPY_VERSION.tar.gz ]; then
  check tar zxf $HOME/source/scipy-$SCIPY_VERSION.tar.gz
else
  check wget -O - http://sourceforge.net/projects/scipy/files/scipy/$SCIPY_VERSION/scipy-$SCIPY_VERSION.tar.gz/download scipy-$SCIPY_VERSION.tar.gz | tar zxf -
fi
cd scipy-$SCIPY_VERSION
LD_LIBRARY_PATH=$PREFIX_OPT/lib:$LD_LIBRARY_PATH check $PREFIX_OPT/bin/python2.7 setup.py config --compiler=intel --fcompiler=intel build_clib --compiler=intel --fcompiler=intel build_ext --compiler=intel --fcompiler=intel
check sudo LD_LIBRARY_PATH=$PREFIX_OPT/lib:$LD_LIBRARY_PATH $PREFIX_OPT/bin/python2.7 setup.py install

cd $BUILDDIR
rm -rf matplotlib-$MATPLOTLIB_VERSION
if [ -f $HOME/source/matplotlib-$MATPLOTLIB_VERSION.tar.gz ]; then
  check tar zxf $HOME/source/matplotlib-$MATPLOTLIB_VERSION.tar.gz
else
  check wget -O - http://sourceforge.net/projects/matplotlib/files/matplotlib/matplotlib-$MATPLOTLIB_VERSION/matplotlib-$MATPLOTLIB_VERSION.tar.gz/download matplotlib-$MATPLOTLIB_VERSION.tar.gz | tar zxf -
fi
cd matplotlib-$MATPLOTLIB_VERSION
LD_LIBRARY_PATH=$PREFIX_OPT/lib:$LD_LIBRARY_PATH check $PREFIX_OPT/bin/python2.7 setup.py build
check sudo LD_LIBRARY_PATH=$PREFIX_OPT/lib:$LD_LIBRARY_PATH $PREFIX_OPT/bin/python2.7 setup.py install
