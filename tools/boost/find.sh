#!/bin/sh

SCRIPT_DIR=$(cd "$(dirname $0)"; pwd)

MA_HAVE_BOOST=no
MA_BOOST_VERSION=$(sh ${SCRIPT_DIR}/../../scripts/cmake-find-package.sh Boost)
MA_BOOST_VERSION_MAJOR=$(echo ${MA_BOOST_VERSION} | cut -d . -f 1)
MA_BOOST_VERSION_MINOR=$(echo ${MA_BOOST_VERSION} | cut -d . -f 2)
MA_BOOST_VERSION_PATCH=$(echo ${MA_BOOST_VERSION} | cut -d . -f 3)

if [ -n "${MA_BOOST_VERSION}" ]; then
  MA_HAVE_BOOST=yes
fi

<< "#__COMMENT__"
  echo "MA_HAVE_BOOST=${MA_HAVE_BOOST}"
  echo "MA_BOOST_VERSION=${MA_BOOST_VERSION}"
  echo "MA_BOOST_VERSION_MAJOR=${MA_BOOST_VERSION_MAJOR}"
  echo "MA_BOOST_VERSION_MINOR=${MA_BOOST_VERSION_MINOR}"
  echo "MA_BOOST_VERSION_PATCH=${MA_BOOST_VERSION_PATCH}"
#__COMMENT__
