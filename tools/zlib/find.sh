#!/bin/sh

SCRIPT_DIR=$(cd "$(dirname $0)"; pwd)

MA_HAVE_ZLIB=no
MA_ZLIB_VERSION=
MA_ZLIB_VERSION_MAJOR=
MA_ZLIB_VERSION_MINOR=
MA_ZLIB_VERSION_PATCH=

for cc in cc gcc icc; do __CC__=$(which ${cc}); test -n ${__CC__} && break; done
cat <<EOF > test-$$.c
#include <zlib.h>
#include <stdio.h>
int main() { printf("%s\n", ZLIB_VERSION); }
EOF
${__CC__} test-$$.c -o test-$$ -I${ZLIB_ROOT:-/usr}/include -L${ZLIB_ROOT:-/usr}/lib -lz > /dev/null 2>&1
if [ $? = 0 ]; then
  MA_ZLIB_VERSION=$(./test-$$)
  MA_ZLIB_VERSION_MAJOR=$(echo ${MA_ZLIB_VERSION} | cut -d . -f 1)
  MA_ZLIB_VERSION_MINOR=$(echo ${MA_ZLIB_VERSION} | cut -d . -f 2)
  MA_ZLIB_VERSION_PATCH=$(echo ${MA_ZLIB_VERSION} | cut -d . -f 3)
fi
rm -f test-$$.c test-$$

if [ -n "${MA_ZLIB_VERSION}" ]; then
  MA_HAVE_ZLIB=yes
fi

<< "#__COMMENT__"
  echo "MA_HAVE_ZLIB=${MA_HAVE_ZLIB}"
  echo "MA_ZLIB_VERSION=${MA_ZLIB_VERSION}"
  echo "MA_ZLIB_VERSION_MAJOR=${MA_ZLIB_VERSION_MAJOR}"
  echo "MA_ZLIB_VERSION_MINOR=${MA_ZLIB_VERSION_MINOR}"
  echo "MA_ZLIB_VERSION_PATCH=${MA_ZLIB_VERSION_PATCH}"
#__COMMENT__
