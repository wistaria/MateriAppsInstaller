#!/bin/sh

MA_HAVE_PYTHON3=no
MA_PYTHON3_VERSION=
MA_PYTHON3_VERSION_MAJOR=
MA_PYTHON3_VERSION_MINOR=
MA_PYTHON3_VERSION_PATCH=

if [ -z "$MA_PYTHON3" ]; then
  which python3 2>/dev/null && MA_PYTHON3=$(which python3)
  if [ -z "$MA_PYTHON3" ]; then
    which python 2>/dev/null && MA_PYTHON3=$(which python)
  fi
else
  if [ ! -x "$MA_PYTHON3" ]; then
    echo "MA_PYTHON3 is manually set but this looks not an executable"
    exit 127
  fi
fi

if [ -n "${MA_PYTHON3}" ]; then
  if [ $(${MA_PYTHON3} -c "import sys; print(sys.version_info.major)") = 3 ]; then
    MA_PYTHON3_VERSION=$(${MA_PYTHON3} -c "import sys; print('{}.{}.{}'.format(sys.version_info.major, sys.version_info.minor, sys.version_info.micro))")
    MA_PYTHON3_VERSION_MAJOR=$(${MA_PYTHON3} -c "import sys; print(sys.version_info.major)")
    MA_PYTHON3_VERSION_MINOR=$(${MA_PYTHON3} -c "import sys; print(sys.version_info.minor)")
    MA_PYTHON3_VERSION_PATCH=$(${MA_PYTHON3} -c "import sys; print(sys.version_info.micro)")
  fi
fi

if [ -n "${MA_PYTHON3_VERSION}" ]; then
  MA_HAVE_PYTHON3=yes
fi

<< "#__COMMENT__"
  echo "MA_HAVE_PYTHON3=${MA_HAVE_PYTHON3}"
  echo "MA_PYTHON3=${MA_PYTHON3}"
  echo "MA_PYTHON3_VERSION=${MA_PYTHON3_VERSION}"
  echo "MA_PYTHON3_VERSION_MAJOR=${MA_PYTHON3_VERSION_MAJOR}"
  echo "MA_PYTHON3_VERSION_MINOR=${MA_PYTHON3_VERSION_MINOR}"
  echo "MA_PYTHON3_VERSION_PATCH=${MA_PYTHON3_VERSION_PATCH}"
#__COMMENT__
