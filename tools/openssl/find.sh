#!/bin/sh

SCRIPT_DIR=$(cd "$(dirname $0)"; pwd)

MA_HAVE_OPENSSL=no
MA_OPENSSL=$(which openssl)
MA_OPENSSL_VERSION=
MA_OPENSSL_VERSION_MAJOR=
MA_OPENSSL_VERSION_MINOR=
MA_OPENSSL_VERSION_PATCH=

if [ -n "${MA_OPENSSL}" ]; then
  for cc in cc gcc icc; do __CC__=$(which ${cc}); test -n ${__CC__} && break; done
  echo "void SSL_CTX_new(); int main() { SSL_CTX_new(); }" > test-$$.c
  ${__CC__} test-$$.c -o test-$$ -L${OPENSSL_ROOT}/lib -L/opt/local/lib -lssl > /dev/null 2>&1
  if [ $? = 0 ]; then
    MA_OPENSSL_VERSION=$(${MA_OPENSSL} version | awk '{print $2}')
    MA_OPENSSL_VERSION_MAJOR=$(echo ${MA_OPENSSL_VERSION} | cut -d . -f 1)
    MA_OPENSSL_VERSION_MINOR=$(echo ${MA_OPENSSL_VERSION} | cut -d . -f 2)
    MA_OPENSSL_VERSION_PATCH=$(echo ${MA_OPENSSL_VERSION} | cut -d . -f 3)
  fi
  rm -f test-$$.c test-$$
fi

if [ -n "${MA_OPENSSL_VERSION}" ]; then
  MA_HAVE_OPENSSL=yes
fi

<< "#__COMMENT__"
  echo "MA_HAVE_OPENSSL=${MA_HAVE_OPENSSL}"
  echo "MA_OPENSSL=${MA_OPENSSL}"
  echo "MA_OPENSSL_VERSION=${MA_OPENSSL_VERSION}"
  echo "MA_OPENSSL_VERSION_MAJOR=${MA_OPENSSL_VERSION_MAJOR}"
  echo "MA_OPENSSL_VERSION_MINOR=${MA_OPENSSL_VERSION_MINOR}"
  echo "MA_OPENSSL_VERSION_PATCH=${MA_OPENSSL_VERSION_PATCH}"
#__COMMENT__
