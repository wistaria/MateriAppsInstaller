#!/bin/sh

MA_HAVE_PYTHON3=no
MA_HAVE_PYTHON3_PYCONFIG=no
MA_HAVE_PYTHON3_NUMPY=no
MA_HAVE_PYTHON3_SCIPY=no
MA_PYTHON3=$(which python3)
test -n "${MA_PYTHON3}" || MA_PYTHON3=$(which python)
MA_PYTHON3_VERSION=
MA_PYTHON3_VERSION_MAJOR=
MA_PYTHON3_VERSION_MINOR=
MA_PYTHON3_VERSION_PATCH=

if [ -n "${MA_PYTHON3}" ]; then
  if [ $(${MA_PYTHON3} -c "import sys; print(sys.version_info.major)") = 3 ]; then
    MA_PYTHON3_CONFIG=$(which ${MA_PYTHON3}-config)
    if [ -n "${MA_PYTHON3_CONFIG}" ]; then
      for cc in cc gcc icc; do __CC__=$(which ${cc}); test -n ${__CC__} && break; done
      cat <<EOF > test-$$.c
#include <pyconfig.h>
int main() {}
EOF
      ${__CC__} test-$$.c -o test-$$ $(${MA_PYTHON3_CONFIG} --include) > /dev/null 2>&1 && MA_HAVE_PYTHON3_PYCONFIG=yes
      rm -f test-$$.c test-$$
    fi
    ${MA_PYTHON3} -c "import numpy" > /dev/null 2>&1 && MA_HAVE_PYTHON3_NUMPY=yes
    ${MA_PYTHON3} -c "import scipy" > /dev/null 2>&1 && MA_HAVE_PYTHON3_SCIPY=yes
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
