#!/bin/sh

MA_HAVE_GIT=no
MA_GIT=$(which git)
MA_GIT_VERSION=
MA_GIT_VERSION_MAJOR=
MA_GIT_VERSION_MINOR=
MA_GIT_VERSION_PATCH=

if [ -n "${MA_GIT}" ]; then
  MA_GIT_VERSION=$(${MA_GIT} --version | awk '{print $3}')
  MA_GIT_VERSION_MAJOR=$(echo ${MA_GIT_VERSION} | cut -d . -f 1)
  MA_GIT_VERSION_MINOR=$(echo ${MA_GIT_VERSION} | cut -d . -f 2)
  MA_GIT_VERSION_PATCH=$(echo ${MA_GIT_VERSION} | cut -d . -f 3)
fi

if [ -n "${MA_GIT_VERSION}" ]; then
  MA_HAVE_GIT=yes
fi

<< "#__COMMENT__"
  echo "MA_HAVE_GIT=${MA_HAVE_GIT}"
  echo "MA_GIT=${MA_GIT}"
  echo "MA_GIT_VERSION=${MA_GIT_VERSION}"
  echo "MA_GIT_VERSION_MAJOR=${MA_GIT_VERSION_MAJOR}"
  echo "MA_GIT_VERSION_MINOR=${MA_GIT_VERSION_MINOR}"
  echo "MA_GIT_VERSION_PATCH=${MA_GIT_VERSION_PATCH}"
#__COMMENT__
