#!/bin/sh

set_prefix() {
  PREFIX_OPT_DEF="$HOME/opt"
  PREFIX_ALPS_DEF="$HOME/alps"

  # for Mac OS X
  if [ `uname` = Darwin ]; then
    if [ -d /opt/alps ]; then
      PREFIX_OPT_DEF="/opt/alps"
      PREFIX_ALPS_DEF="/opt/alps"
    fi
  fi

  # for k.aics.riken.jp
  if [[ `hostname -f` =~ fe01p.*\.k ]]; then
    PREFIX_OPT_DEF="/data/share002/opt"
    PREFIX_ALPS_DEF="/data/share002/alps"
  fi

  # for maki.issp.u-tokyo.ac.jp
  if [[ `hostname -f` =~ maki.\.fx10hpc ]]; then
    PREFIX_OPT_DEF="/global/nano/alps"
    PREFIX_ALPS_DEF="/global/nano/alps"
  fi

  if [ -d /opt/local -a -d /opt/nano/alps ]; then
    PREFIX_OPT_DEF="/opt/local"
    PREFIX_ALPS_DEF="/opt/nano/alps"
  fi

  if [ -z "$PREFIX_OPT" ]; then
    PREFIX_OPT="$PREFIX_OPT_DEF"
  fi
  if [ -z "$PREFIX_ALPS" ]; then
    PREFIX_ALPS="$PREFIX_ALPS_DEF"
  fi
  echo "PREFIX_OPT = $PREFIX_OPT"
  echo "PREFIX_ALPS = $PREFIX_ALPS"
  return 0
}

set_build_dir() {
  if [ -z "$BUILD_DIR" ]; then
    BUILD_DIR="$HOME/build"
  fi
  mkdir -p "$BUILD_DIR"
}

check() {
  "$@"
  result=$?
  if [ $result -ne 0 ]; then
    echo "Failed: $@" >&2
    exit $result
  fi
  return 0
}
