#!/bin/sh

SCRIPT_DIR=$(cd "$(dirname $0)"; pwd)
. $SCRIPT_DIR/../util.sh
set_prefix
. $PREFIX_TOOL/env.sh
. $SCRIPT_DIR/version.sh

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
    check wget http://pypi.python.org/packages/source/n/numpy/numpy-$NUMPY_VERSION.tar.gz
    check tar zxf numpy-$NUMPY_VERSION.tar.gz
  fi
fi

if [ -d scipy-$SCIPY_VERSION ]; then :; else
  if [ -f $HOME/source/scipy-$SCIPY_VERSION.tar.gz ]; then
    check tar zxf $HOME/source/scipy-$SCIPY_VERSION.tar.gz
  else
    check wget http://pypi.python.org/packages/source/s/scipy/scipy-$SCIPY_VERSION.tar.gz
    check tar zxf scipy-$SCIPY_VERSION.tar.gz
  fi
fi

if [ -d matplotlib-$MATPLOTLIB_VERSION ]; then :; else
  if [ -f $HOME/source/matplotlib-$MATPLOTLIB_VERSION.tar.gz ]; then
    check tar zxf $HOME/source/matplotlib-$MATPLOTLIB_VERSION.tar.gz
  else
    check wget http://pypi.python.org/packages/source/m/matplotlib/matplotlib-$MATPLOTLIB_VERSION.tar.gz
    check tar zxf matplotlib-$MATPLOTLIB_VERSION.tar.gz
  fi
fi

# pexpect
if [ -d pexpect-$PEXPECT_VERSION ]; then :; else
  if [ -f $HOME/source/pexpect-$PEXPECT_VERSION.tar.gz ]; then
    check tar zxf $HOME/source/pexpect-$PEXPECT_VERSION.tar.gz
  else
    check wget http://pypi.python.org/packages/source/p/pexpect/pexpect-$PEXPECT_VERSION.tar.gz
    check tar zxf pexpect-$PEXPECT_VERSION.tar.gz
  fi
fi

# MarkupSafe
if [ -d MarkupSafe-$MARKUPSAFE_VERSION ]; then :; else
  if [ -f $HOME/source/MarkupSafe-$MARKUPSAFE_VERSION.tar.gz ]; then
    check tar zxf $HOME/source/MarkupSafe-$MARKUPSAFE_VERSION.tar.gz
  else
    check wget http://pypi.python.org/packages/source/M/MarkupSafe/MarkupSafe-$MARKUPSAFE_VERSION.tar.gz
    check tar zxf MarkupSafe-$MARKUPSAFE_VERSION.tar.gz
  fi
fi

# Jinja2
if [ -d Jinja2-$JINJA2_VERSION ]; then :; else
  if [ -f $HOME/source/Jinja2-$JINJA2_VERSION.tar.gz ]; then
    check tar zxf $HOME/source/Jinja2-$JINJA2_VERSION.tar.gz
  else
    check wget http://pypi.python.org/packages/source/J/Jinja2/Jinja2-$JINJA2_VERSION.tar.gz
    check tar zxf Jinja2-$JINJA2_VERSION.tar.gz
  fi
fi

# docutils
if [ -d docutils-$DOCUTILS_VERSION ]; then :; else
  if [ -f $HOME/source/docutils-$DOCUTILS_VERSION.tar.gz ]; then
    check tar zxf $HOME/source/docutils-$DOCUTILS_VERSION.tar.gz
  else
    check wget http://pypi.python.org/packages/source/d/docutils/docutils-$DOCUTILS_VERSION.tar.gz
    check tar zxf docutils-$DOCUTILS_VERSION.tar.gz
  fi
fi

# Pygments
if [ -d Pygments-$PYGMENTS_VERSION ]; then :; else
  if [ -f $HOME/source/Pygments-$PYGMENTS_VERSION.tar.gz ]; then
    check tar zxf $HOME/source/Pygments-$PYGMENTS_VERSION.tar.gz
  else
    check wget http://pypi.python.org/packages/source/P/Pygments/Pygments-$PYGMENTS_VERSION.tar.gz
    check tar zxf Pygments-$PYGMENTS_VERSION.tar.gz
  fi
fi

# sphinx_rtd_theme
if [ -d sphinx_rtd_theme-$SPHINX_RTD_THEME_VERSION ]; then :; else
  if [ -f $HOME/source/sphinx_rtd_theme-$SPHINX_RTD_THEME_VERSION.tar.gz ]; then
    check tar zxf $HOME/source/sphinx_rtd_theme-$SPHINX_RTD_THEME_VERSION.tar.gz
  else
    check wget http://pypi.python.org/packages/source/s/sphinx_rtd_theme/sphinx_rtd_theme-$SPHINX_RTD_THEME_VERSION.tar.gz
    check tar zxf sphinx_rtd_theme-$SPHINX_RTD_THEME_VERSION.tar.gz
  fi
fi

# alabaster
if [ -d alabaster-$ALABASTER_VERSION ]; then :; else
  if [ -f $HOME/source/alabaster-$ALABASTER_VERSION.tar.gz ]; then
    check tar zxf $HOME/source/alabaster-$ALABASTER_VERSION.tar.gz
  else
    check wget http://pypi.python.org/packages/source/a/alabaster/alabaster-$ALABASTER_VERSION.tar.gz
    check tar zxf alabaster-$ALABASTER_VERSION.tar.gz
  fi
fi

# sphinx
if [ -d  Sphinx-$SPHINX_VERSION ]; then :; else
  if [ -f $HOME/source/Sphinx-$SPHINX_VERSION.tar.gz ]; then
    check tar zxf $HOME/source/Sphinx-$SPHINX_VERSION.tar.gz
  else
    check wget http://pypi.python.org/packages/source/S/Sphinx/Sphinx-$SPHINX_VERSION.tar.gz
    check tar zxf Sphinx-$SPHINX_VERSION.tar.gz
  fi
fi

# pyzmq
if [ -d  pyzmq-$PYZMQ_VERSION ]; then :; else
  if [ -f $HOME/source/pyzmq-$PYZMQ_VERSION.tar.gz ]; then
    check tar zxf $HOME/source/pyzmq-$PYZMQ_VERSION.tar.gz
  else
    check wget http://pypi.python.org/packages/source/p/pyzmq/pyzmq-$PYZMQ_VERSION.tar.gz
    check tar zxf pyzmq-$PYZMQ_VERSION.tar.gz
  fi
fi

# backports.ssl_match_hostname
if [ -d backports.ssl_match_hostname-$BACKPORTS_SSL_MATCH_HOSTNAME_VERSION ]; then :; else
  if [ -f $HOME/source/backports.ssl_match_hostname-$BACKPORTS_SSL_MATCH_HOSTNAME_VERSION.tar.gz ]; then
    check tar zxf $HOME/source/backports.ssl_match_hostname-$BACKPORTS_SSL_MATCH_HOSTNAME_VERSION.tar.gz
  else
    check wget http://pypi.python.org/packages/source/b/backports.ssl_match_hostname/backports.ssl_match_hostname-$BACKPORTS_SSL_MATCH_HOSTNAME_VERSION.tar.gz
    check tar zxf backports.ssl_match_hostname-$BACKPORTS_SSL_MATCH_HOSTNAME_VERSION.tar.gz
  fi
fi

# certifi
if [ -d certifi-$CERTIFI_VERSION ]; then :; else
  if [ -f $HOME/source/certifi-$CERTIFI_VERSION.tar.gz ]; then
    check tar zxf $HOME/source/certifi-$CERTIFI_VERSION.tar.gz
  else
    check wget http://pypi.python.org/packages/source/c/certifi/certifi-$CERTIFI_VERSION.tar.gz
    check tar zxf certifi-$CERTIFI_VERSION.tar.gz
  fi
fi

# tornado
if [ -d tornado-$TORNADO_VERSION ]; then :; else
  if [ -f $HOME/source/tornado-$TORNADO_VERSION.tar.gz ]; then
    check tar zxf $HOME/source/tornado-$TORNADO_VERSION.tar.gz
  else
    check wget http://pypi.python.org/packages/source/t/tornado/tornado-$TORNADO_VERSION.tar.gz
    check tar zxf tornado-$TORNADO_VERSION.tar.gz
  fi
fi

# ipython
if [ -d ipython-$IPYTHON_VERSION ]; then :; else
  if [ -f $HOME/source/ipython-$IPYTHON_VERSION.tar.gz ]; then
    check tar zxf $HOME/source/ipython-$IPYTHON_VERSION.tar.gz
  else
    check wget http://pypi.python.org/packages/source/i/ipython/ipython-$IPYTHON_VERSION.tar.gz
    check tar zxf ipython-$IPYTHON_VERSION.tar.gz
  fi
fi
