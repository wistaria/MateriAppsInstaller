#!/bin/sh

set_prefix() {
  if [ -n "$__MAINSTALLER__SET_PREFIX__" ]; then
    return 0
  fi
  export __MAINSTALLER__SET_PREFIX__=true

  MAINSTALLER_CONFIG_DEF="$HOME/.mainstaller"
  PREFIX_DEF="$HOME/materiapps"
  BUILD_DIR_DEF="$HOME/build"
  SOURCE_DIR_DEF="$HOME/source"
  MALIVE_REPOSITORY_DEF="http://download.sourceforge.net/project/materiappslive/Debian/archive/stretch"

  if [ -n "$MAINSTALLER_CONFIG" ]; then
    if [ -f "$MAINSTALLER_CONFIG" ]; then
      . "$MAINSTALLER_CONFIG"
    else
      echo "Warning: configuration file ($MAINSTALLER_CONFIG) not found. Skipped."
    fi
  else
    if [ -f "$MAINSTALLER_CONFIG_DEF" ]; then
      . "$MAINSTALLER_CONFIG_DEF"
    fi
  fi

  if [ -z "$PREFIX" ]; then
    PREFIX="$PREFIX_DEF"
  fi
  if [ -d "$PREFIX" ]; then :; else
    echo "Fatal: target directory $PREFIX does not exist!"
    exit 127
  fi
  export PREFIX

  if [ -z "$BUILD_DIR" ]; then
    BUILD_DIR="$BUILD_DIR_DEF"
  fi
  if [ -d "$BUILD_DIR" ]; then :; else
    echo "Fatal: target directory $BUILD_DIR does not exist!"
    exit 127
  fi
  RES=$(touch $BUILD_DIR/.mainstaller.tmp > /dev/null 2>&1; echo $?; rm -f $BUILD_DIR/.mainstaller.tmp)
  if [ $RES = 0 ]; then :; else
    echo "Fatal: have no permission to write in build directory $BUILD_DIR"
    exit 127
  fi
  export BUILD_DIR

  if [ -z "$SOURCE_DIR" ]; then
    SOURCE_DIR="$SOURCE_DIR_DEF"
  fi
  if [ -d "$SOURCE_DIR" ]; then :; else
    echo "Fatal: target directory $SOURCE_DIR does not exist!"
    exit 127
  fi
  export SOURCE_DIR

  if [ -z "$MALIVE_REPOSITORY" ]; then
    MALIVE_REPOSITORY="$MALIVE_REPOSITORY_DEF"
  fi
  export MALIVE_REPOSITORY

  export WGET_OPTION

  return 0
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

print_prefix() {
  echo "PREFIX=$PREFIX"
  echo "BUILD_DIR=$BUILD_DIR"
  echo "SOURCE_DIR=$SOURCE_DIR"
  echo "MALIVE_REPOSITORY=$MALIVE_REPOSITORY"
  echo "WGET_OPTION=$WGET_OPTION"
}

start_info() {
  echo "Start: $(date) on $(hostname)"
}

finish_info() {
  echo "Finish: $(date)"
}

calc_strip_components(){
  if [ $# -lt 2 ];then
    echo "usage: calc_strip_components tarfile file_in_rootdir"
  fi
  tar tf $1 | grep $2 | awk -F / 'BEGIN {res=99999}; {if (NF<res) res=NF}; END{print res-1}'
}
