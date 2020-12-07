#!/bin/sh

SCRIPT_DIR=$(cd "$(dirname $0)"; pwd)

MA_HAVE_LAPACK=no
MA_LAPACK_FOUND=$(sh ${SCRIPT_DIR}/../../scripts/cmake-find-package.sh LAPACK)

if [ "${MA_LAPACK_FOUND}" = yes ]; then
  MA_HAVE_BLAS=yes
  MA_HAVE_LAPACK=yes
fi

<< "#__COMMENT__"
  echo "MA_HAVE_BLAS=${MA_HAVE_BLAS}"
  echo "MA_HAVE_LAPACK=${MA_HAVE_LAPACK}"
#__COMMENT__
