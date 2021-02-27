#!/bin/sh

SCRIPT_DIR=$(cd "$(dirname $0)"; pwd)

MA_HAVE_GSL=no
MA_GSL_VERSION=
MA_GSL_VERSION_MAJOR=
MA_GSL_VERSION_MINOR=
MA_GSL_VERSION_PATCH=

for cc in cc gcc icc; do __CC__=$(which ${cc}); test -n ${__CC__} && break; done
echo "void gsl_version(); int main() { gsl_version(); return 0; }" > test-$$.c
${__CC__} test-$$.c -o test-$$ -L${GSL_ROOT}/lib -lgsl -lgslcblas > /dev/null 2>&1
if [ $? = 0 ]; then
  MA_GSL_VERSION=$(gsl-config --version)
  MA_GSL_VERSION_MAJOR=$(echo ${MA_GSL_VERSION} | cut -d . -f 1)
  MA_GSL_VERSION_MINOR=$(echo ${MA_GSL_VERSION} | cut -d . -f 2)
fi
rm -f test-$$.c test-$$

if [ -n "${MA_GSL_VERSION}" ]; then
  MA_HAVE_GSL=yes
fi

<< "#__COMMENT__"
  echo "MA_HAVE_GSL=${MA_HAVE_GSL}"
  echo "MA_GSL_VERSION=${MA_GSL_VERSION}"
  echo "MA_GSL_VERSION_MAJOR=${MA_GSL_VERSION_MAJOR}"
  echo "MA_GSL_VERSION_MINOR=${MA_GSL_VERSION_MINOR}"
#__COMMENT__
