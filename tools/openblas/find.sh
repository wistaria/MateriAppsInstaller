#!/bin/sh

SCRIPT_DIR=$(cd "$(dirname $0)"; pwd)

test -n "$(sh ${SCRIPT_DIR}/../../scripts/cmake-find-package.sh BLAS)" && MA_HAVE_BLAS=yes || MA_HAVE_BLAS=no

<< "#__COMMENT__"
  echo "MA_HAVE_BLAS=${MA_HAVE_BLAS}"
#__COMMENT__
