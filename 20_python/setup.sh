#!/bin/sh

SCRIPT_DIR=$(cd "$(dirname $0)"; pwd)
. $SCRIPT_DIR/../util.sh
. $SCRIPT_DIR/version.sh
set_prefix

cd $BUILD_DIR

if [ -d Python-$PYTHON_VERSION ]; then :; else
  if [ -f $HOME/source/Python-$PYTHON_VERSION.tgz ]; then
    check tar zxf $HOME/source/Python-$PYTHON_VERSION.tgz
  else
    check wget http://www.python.org/ftp/python/$PYTHON_VERSION/Python-$PYTHON_VERSION.tgz
    check tar zxf Python-$PYTHON_VERSION.tgz
  fi
fi

if [ -d nose-$NOSE_VERSION ]; then :; else
  if [ -f $HOME/source/nose-$NOSE_VERSION.tar.gz ]; then
    check tar zxf $HOME/source/nose-$NOSE_VERSION.tar.gz
  else
    check wget http://pypi.python.org/packages/source/n/nose/nose-$NOSE_VERSION.tar.gz
    check tar zxf nose-$NOSE_VERSION.tar.gz
  fi
fi

if [ -d distribute-$DISTRIBUTE_VERSION ]; then :; else
  if [ -f $HOME/source/distribute-$DISTRIBUTE_VERSION.tar.gz ]; then
    check tar zxf $HOME/source/distribute-$DISTRIBUTE_VERSION.tar.gz
  else
    check wget http://pypi.python.org/packages/source/d/distribute/distribute-$DISTRIBUTE_VERSION.tar.gz
    check tar zxf distribute-$DISTRIBUTE_VERSION.tar.gz
  fi
fi

if [ -d mock-$MOCK_VERSION ]; then :; else
  if [ -f $HOME/source/mock-$MOCK_VERSION.tar.gz ]; then
    check tar zxf $HOME/source/mock-$MOCK_VERSION.tar.gz
  else
    check wget http://pypi.python.org/packages/source/m/mock/mock-$MOCK_VERSION.tar.gz
    check tar zxf mock-$MOCK_VERSION.tar.gz
  fi
fi

if [ -d pyparsing-$PYPARSING_VERSION ]; then :; else
  if [ -f $HOME/source/pyparsing-$PYPARSING_VERSION.tar.gz ]; then
    check tar zxf $HOME/source/pyparsing-$PYPARSING_VERSION.tar.gz
  else
    check wget http://pypi.python.org/packages/source/p/pyparsing/pyparsing-$PYPARSING_VERSION.tar.gz
    check tar zxf pyparsing-$PYPARSING_VERSION.tar.gz
  fi
fi

if [ -d pytz-$PYTZ_VERSION ]; then :; else
  if [ -f $HOME/source/pytz-$PYTZ_VERSION.tar.gz ]; then
    check tar zxf $HOME/source/pytz-$PYTZ_VERSION.tar.gz
  else
    check wget http://pypi.python.org/packages/source/p/pytz/pytz-$PYTZ_VERSION.tar.gz
    check tar zxf pytz-$PYTZ_VERSION.tar.gz
  fi
fi

if [ -d python-dateutil-$PYTHON_DATEUTIL_VERSION ]; then :; else
  if [ -f $HOME/source/python-dateutil-$PYTHON_DATEUTIL_VERSION.tar.gz ]; then
    check tar zxf $HOME/source/python-dateutil-$PYTHON_DATEUTIL_VERSION.tar.gz
  else
    check wget http://pypi.python.org/packages/source/p/python-dateutil/python-dateutil-$PYTHON_DATEUTIL_VERSION.tar.gz
    check tar zxf python-dateutil-$PYTHON_DATEUTIL_VERSION.tar.gz
  fi
fi

if [ -d six-$SIX_VERSION ]; then :; else
  if [ -f $HOME/source/six-$SIX_VERSION.tar.gz ]; then
    check tar zxf $HOME/source/six-$SIX_VERSION.tar.gz
  else
    check wget http://pypi.python.org/packages/source/s/six/six-$SIX_VERSION.tar.gz
    check tar zxf six-$SIX_VERSION.tar.gz
  fi
fi

if [ -d numpy-$NUMPY_VERSION ]; then :; else
  if [ -f $HOME/source/numpy-$NUMPY_VERSION.tar.gz ]; then
    check tar zxf $HOME/source/numpy-$NUMPY_VERSION.tar.gz
  else
    check wget -O  numpy-$NUMPY_VERSION.tar.gz http://sourceforge.net/projects/numpy/files/NumPy/$NUMPY_VERSION/numpy-$NUMPY_VERSION.tar.gz/download
    check tar zxf numpy-$NUMPY_VERSION.tar.gz
  fi
fi

if [ -d scipy-$SCIPY_VERSION ]; then :; else
  if [ -f $HOME/source/scipy-$SCIPY_VERSION.tar.gz ]; then
    check tar zxf $HOME/source/scipy-$SCIPY_VERSION.tar.gz
  else
    check wget -O scipy-$SCIPY_VERSION.tar.gz http://sourceforge.net/projects/scipy/files/scipy/$SCIPY_VERSION/scipy-$SCIPY_VERSION.tar.gz/download
    check tar zxf scipy-$SCIPY_VERSION.tar.gz
  fi
fi

if [ -d matplotlib-$MATPLOTLIB_VERSION ]; then :; else
  if [ -f $HOME/source/matplotlib-$MATPLOTLIB_VERSION.tar.gz ]; then
    check tar zxf $HOME/source/matplotlib-$MATPLOTLIB_VERSION.tar.gz
  else
    check wget -O  matplotlib-$MATPLOTLIB_VERSION.tar.gz http://sourceforge.net/projects/matplotlib/files/matplotlib/matplotlib-$MATPLOTLIB_VERSION/matplotlib-$MATPLOTLIB_VERSION.tar.gz/download
    check tar zxf matplotlib-$MATPLOTLIB_VERSION.tar.gz
  fi
fi
