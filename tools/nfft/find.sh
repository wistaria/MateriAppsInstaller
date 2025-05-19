#!/bin/sh

SCRIPT_DIR=$(cd "$(dirname $0)"; pwd)

MA_HAVE_FFTW=no
MA_FFTW_VERSION=$(sh ${SCRIPT_DIR}/../../scripts/cmake-find-package.sh FFTW3)
MA_FFTW_VERSION_MAJOR=$(echo ${MA_FFTW_VERSION} | cut -d . -f 1)
MA_FFTW_VERSION_MINOR=$(echo ${MA_FFTW_VERSION} | cut -d . -f 2)
MA_FFTW_VERSION_PATCH=$(echo ${MA_FFTW_VERSION} | cut -d . -f 3)

if [ -n "${MA_FFTW_VERSION}" ]; then
  MA_HAVE_FFTW=yes
fi

<< "#__COMMENT__"
  echo "MA_HAVE_FFTW=${MA_HAVE_FFTW}"
  echo "MA_FFTW=${MA_FFTW}"
  echo "MA_FFTW_VERSION=${MA_FFTW_VERSION}"
  echo "MA_FFTW_VERSION_MAJOR=${MA_FFTW_VERSION_MAJOR}"
  echo "MA_FFTW_VERSION_MINOR=${MA_FFTW_VERSION_MINOR}"
  echo "MA_FFTW_VERSION_PATCH=${MA_FFTW_VERSION_PATCH}"
#__COMMENT__
