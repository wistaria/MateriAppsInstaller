#!/bin/sh

SCRIPT_DIR=$(cd "$(dirname $0)"; pwd)

MA_HAVE_HDF5=no
MA_HDF5_VERSION=$(sh ${SCRIPT_DIR}/../../scripts/cmake-find-package.sh HDF5)
MA_HDF5_VERSION_MAJOR=$(echo ${MA_HDF5_VERSION} | cut -d . -f 1)
MA_HDF5_VERSION_MINOR=$(echo ${MA_HDF5_VERSION} | cut -d . -f 2)
MA_HDF5_VERSION_PATCH=$(echo ${MA_HDF5_VERSION} | cut -d . -f 3)

if [ -n ${MA_HDF5_VERSION} ]; then
  MA_HAVE_HDF5=yes
fi

<< "#__COMMENT__"
  echo "MA_HAVE_HDF5=${MA_HAVE_HDF5}"
  echo "MA_HDF5_VERSION=${MA_HDF5_VERSION}"
  echo "MA_HDF5_VERSION_MAJOR=${MA_HDF5_VERSION_MAJOR}"
  echo "MA_HDF5_VERSION_MINOR=${MA_HDF5_VERSION_MINOR}"
  echo "MA_HDF5_VERSION_PATCH=${MA_HDF5_VERSION_PATCH}"
#__COMMENT__
