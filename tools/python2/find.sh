#!/bin/sh

MA_HAVE_PYTHON2=no
MA_HAVE_PYTHON2_PYCONFIG=no
MA_HAVE_PYTHON2_NUMPY=no
MA_HAVE_PYTHON2_SCIPY=no
MA_PYTHON2=$(which python2)
test -n "${MA_PYTHON2}" || MA_PYTHON2=$(which python)
MA_PYTHON2_VERSION=
MA_PYTHON2_VERSION_MAJOR=
MA_PYTHON2_VERSION_MINOR=
MA_PYTHON2_VERSION_PATCH=

if [ -n "${MA_PYTHON2}" ]; then
  if [ $(${MA_PYTHON2} -c "import sys; print(sys.version_info.major)") = 2 ]; then
    MA_PYTHON2_CONFIG=$(which ${MA_PYTHON2}-config)
    if [ -n "${MA_PYTHON2_CONFIG}" ]; then
      for cc in cc gcc icc; do __CC__=$(which ${cc}); test -n ${__CC__} && break; done
      cat <<EOF > test-$$.c
#include <pyconfig.h>
int main() {}
EOF
      ${__CC__} test-$$.c -o test-$$ $(${MA_PYTHON2_CONFIG} --include) > /dev/null 2>&1 && MA_HAVE_PYTHON2_PYCONFIG=yes
      rm -f test-$$.c test-$$
    fi
    ${MA_PYTHON2} -c "import numpy" > /dev/null 2>&1 && MA_HAVE_PYTHON2_NUMPY=yes
    ${MA_PYTHON2} -c "import scipy" > /dev/null 2>&1 && MA_HAVE_PYTHON2_SCIPY=yes
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
