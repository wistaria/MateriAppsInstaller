#!/bin/sh

MA_HAVE_PYTHON2=no
MA_PYTHON2_VERSION=
MA_PYTHON2_VERSION_MAJOR=
MA_PYTHON2_VERSION_MINOR=
MA_PYTHON2_VERSION_PATCH=

if [ -z "$MA_PYTHON2" ]; then
  which python2 2>/dev/null && MA_PYTHON2=$(which python2)
  if [ -z "$MA_PYTHON2" ]; then
    which python 2>/dev/null && MA_PYTHON2=$(which python)
  fi
else
  if [ ! -x "$MA_PYTHON2" ]; then
    echo "MA_PYTHON2 is manually set but this looks not an executable"
    exit 127
  fi
fi

if [ -n "${MA_PYTHON2}" ]; then
  if [ $(${MA_PYTHON2} -c "import sys; print(sys.version_info.major)") = 2 ]; then
    MA_PYTHON2_VERSION=$(${MA_PYTHON2} -c "import sys; print('{}.{}.{}'.format(sys.version_info.major, sys.version_info.minor, sys.version_info.micro))")
    MA_PYTHON2_VERSION_MAJOR=$(${MA_PYTHON2} -c "import sys; print(sys.version_info.major)")
    MA_PYTHON2_VERSION_MINOR=$(${MA_PYTHON2} -c "import sys; print(sys.version_info.minor)")
    MA_PYTHON2_VERSION_PATCH=$(${MA_PYTHON2} -c "import sys; print(sys.version_info.micro)")
  fi
fi

if [ -n "${MA_PYTHON2_VERSION}" ]; then
  MA_HAVE_PYTHON2=yes
fi

<< "#__COMMENT__"
  echo "MA_HAVE_PYTHON2=${MA_HAVE_PYTHON2}"
  echo "MA_PYTHON2=${MA_PYTHON2}"
  echo "MA_PYTHON2_VERSION=${MA_PYTHON2_VERSION}"
  echo "MA_PYTHON2_VERSION_MAJOR=${MA_PYTHON2_VERSION_MAJOR}"
  echo "MA_PYTHON2_VERSION_MINOR=${MA_PYTHON2_VERSION_MINOR}"
  echo "MA_PYTHON2_VERSION_PATCH=${MA_PYTHON2_VERSION_PATCH}"
#__COMMENT__
