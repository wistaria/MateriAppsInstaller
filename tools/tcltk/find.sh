#!/bin/sh

SCRIPT_DIR=$(cd "$(dirname $0)"; pwd)

MA_HAVE_TCLTK=no
MA_TCLSH=$(which tclsh)
MA_WISH=$(which wish)
MA_TCLTK_VERSION=
MA_TCLTK_VERSION_MAJOR=
MA_TCLTK_VERSION_MINOR=

if [ -n "${MA_TCLSH}" -a -n "${MA_WISH}" ]; then
  MA_TCLTK_VERSION=$(echo 'puts $tcl_version;exit 0' | ${MA_TCLSH})
  MA_TCLTK_VERSION_MAJOR=$(echo ${MA_TCLTK_VERSION} | cut -d . -f 1)
  MA_TCLTK_VERSION_MINOR=$(echo ${MA_TCLTK_VERSION} | cut -d . -f 2)
fi

if [ -n "${MA_TCLTK_VERSION}" ]; then
  MA_HAVE_TCLTK=yes
fi

<< "#__COMMENT__"
  echo "MA_HAVE_TCLTK=${MA_HAVE_TCLTK}"
  echo "MA_TCLTK_VERSION=${MA_TCLTK_VERSION}"
  echo "MA_TCLTK_VERSION_MAJOR=${MA_TCLTK_VERSION_MAJOR}"
  echo "MA_TCLTK_VERSION_MINOR=${MA_TCLTK_VERSION_MINOR}"
#__COMMENT__
