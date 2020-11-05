#!/bin/sh

MA_PYTHON3=$(which python3)
test -n "${MA_PYTHON3}" || MA_PYTHON3=$(which python)

MA_PYTHON3_VERSION=
MA_PYTHON3_VERSION_MAJOR=
MA_PYTHON3_VERSION_MINOR=
MA_PYTHON3_VERSION_PATCH=

if [ -n "${MA_PYTHON3}" ]; then
  if [ $(${MA_PYTHON3} -c "import sys; print(sys.version_info.major)") = 3 ]; then
    MA_HAVE_PYTHON3=yes
    MA_PYTHON3_VERSION=$(${MA_PYTHON3} -c "import sys; print('{}.{}.{}'.format(sys.version_info.major, sys.version_info.minor, sys.version_info.micro))")
    MA_PYTHON3_VERSION_MAJOR=$(${MA_PYTHON3} -c "import sys; print(sys.version_info.major)")
    MA_PYTHON3_VERSION_MINOR=$(${MA_PYTHON3} -c "import sys; print(sys.version_info.minor)")
    MA_PYTHON3_VERSION_PATCH=$(${MA_PYTHON3} -c "import sys; print(sys.version_info.micro)")
  fi
fi

<< "#__COMMENT__"
  echo "MA_PYTHON3=${MA_PYTHON3}"
  echo "MA_PYTHON3_VERSION=${MA_PYTHON3_VERSION}"
  echo "MA_PYTHON3_VERSION_MAJOR=${MA_PYTHON3_VERSION_MAJOR}"
  echo "MA_PYTHON3_VERSION_MINOR=${MA_PYTHON3_VERSION_MINOR}"
  echo "MA_PYTHON3_VERSION_PATCH=${MA_PYTHON3_VERSION_PATCH}"
#__COMMENT__
