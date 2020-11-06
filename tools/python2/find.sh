#!/bin/sh

MA_PYTHON2=$(which python2)
test -n "${MA_PYTHON2}" || MA_PYTHON2=$(which python)

MA_PYTHON2_VERSION=
MA_PYTHON2_VERSION_MAJOR=
MA_PYTHON2_VERSION_MINOR=
MA_PYTHON2_VERSION_PATCH=

if [ -n "${MA_PYTHON2}" ]; then
  if [ $(${MA_PYTHON2} -c "import sys; print(sys.version_info.major)") = 2 ]; then
    MA_HAVE_PYTHON2=yes
    MA_PYTHON2_VERSION=$(${MA_PYTHON2} -c "import sys; print('{}.{}.{}'.format(sys.version_info.major, sys.version_info.minor, sys.version_info.micro))")
    MA_PYTHON2_VERSION_MAJOR=$(${MA_PYTHON2} -c "import sys; print(sys.version_info.major)")
    MA_PYTHON2_VERSION_MINOR=$(${MA_PYTHON2} -c "import sys; print(sys.version_info.minor)")
    MA_PYTHON2_VERSION_PATCH=$(${MA_PYTHON2} -c "import sys; print(sys.version_info.micro)")
  fi
fi

<< "#__COMMENT__"
  echo "MA_PYTHON2=${MA_PYTHON2}"
  echo "MA_PYTHON2_VERSION=${MA_PYTHON2_VERSION}"
  echo "MA_PYTHON2_VERSION_MAJOR=${MA_PYTHON2_VERSION_MAJOR}"
  echo "MA_PYTHON2_VERSION_MINOR=${MA_PYTHON2_VERSION_MINOR}"
  echo "MA_PYTHON2_VERSION_PATCH=${MA_PYTHON2_VERSION_PATCH}"
#__COMMENT__
