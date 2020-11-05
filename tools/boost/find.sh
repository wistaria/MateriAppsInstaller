#!/bin/sh

SCRIPT_DIR=$(cd "$(dirname $0)"; pwd)

MA_BOOOT_VERSION=$(sh ${SCRIPT_DIR}/../../scripts/cmake-find-package.sh Boost)
MA_BOOST_VERSION_MAJOR=$(echo ${MA_BOOOT_VERSION} | cut -d . -f 1)
MA_BOOST_VERSION_MINOR=$(echo ${MA_BOOOT_VERSION} | cut -d . -f 2)
MA_BOOST_VERSION_PATCH=$(echo ${MA_BOOOT_VERSION} | cut -d . -f 3)

<< "#__COMMENT__"
  echo "MA_BOOST=${MA_BOOST}"
  echo "MA_BOOST_VERSION=${MA_BOOST_VERSION}"
  echo "MA_BOOST_VERSION_MAJOR=${MA_BOOST_VERSION_MAJOR}"
  echo "MA_BOOST_VERSION_MINOR=${MA_BOOST_VERSION_MINOR}"
  echo "MA_BOOST_VERSION_PATCH=${MA_BOOST_VERSION_PATCH}"
#__COMMENT__
