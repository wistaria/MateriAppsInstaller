#!/bin/sh

set_prefix() {
  if [ -n "$__MAINSTALLER__SET_PREFIX__" ]; then
    return 0
  fi
  export __MAINSTALLER__SET_PREFIX__=true

  MAINSTALLER_CONFIG_DEF="$HOME/.mainstaller"
  MA_ROOT_DEF="$HOME/materiapps"
  BUILD_DIR_DEF="$HOME/build"
  SOURCE_DIR_DEF="$HOME/source"
  MALIVE_REPOSITORY_DEF="http://download.sourceforge.net/project/materiappslive/Debian/archive/buster"

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

  if [ -z "$MA_ROOT" ]; then
    MA_ROOT="$MA_ROOT_DEF"
  fi
  if [ -d "$MA_ROOT" ]; then :; else
    mkdir -p $MA_ROOT || exit 127
    echo "Notice: target directory $MA_ROOT has been created"
  fi
  export MA_ROOT
  PREFIX_TOOL="$MA_ROOT"
  PREFIX_APPS="$MA_ROOT"
  export PREFIX_TOOL PREFIX_APPS

  if [ -z "$BUILD_DIR" ]; then
    BUILD_DIR="$BUILD_DIR_DEF"
  fi
  if [ -d "$BUILD_DIR" ]; then :; else
    mkdir -p $BUILD_DIR || exit 127
    echo "Notice: build directory $BUILD_DIR has been created"
  fi
  RES=0
  touch $BUILD_DIR/.mainstaller.tmp > /dev/null 2>&1 || RES=$?
  rm -f $BUILD_DIR/.mainstaller.tmp
  if [ $RES = 0 ]; then :; else
    echo "Fatal: have no permission to write in build directory $BUILD_DIR"
    exit 127
  fi
  export BUILD_DIR

  if [ -z "$SOURCE_DIR" ]; then
    SOURCE_DIR="$SOURCE_DIR_DEF"
  fi
  if [ -d "$SOURCE_DIR" ]; then :; else
    mkdir -p $SOURCE_DIR || exit 127
    echo "Notice: source directory $SOURCE_DIR has been created"
  fi
  export SOURCE_DIR

  if [ -z "$MALIVE_REPOSITORY" ]; then
    MALIVE_REPOSITORY="$MALIVE_REPOSITORY_DEF"
  fi
  export MALIVE_REPOSITORY

  return 0
}

check() {
  local result=0
  echo "$@" 2>&1
  "$@" || result=$?
  if [ $result -ne 0 ]; then
    echo "Failed: $@"
    exit $result
  fi
  return 0
}

print_prefix() {
  echo "MA_ROOT=$MA_ROOT"
  echo "BUILD_DIR=$BUILD_DIR"
  echo "SOURCE_DIR=$SOURCE_DIR"
  echo "MALIVE_REPOSITORY=$MALIVE_REPOSITORY"
}

start_info() {
  echo "Start: $(date) on $(hostname)"
}

finish_info() {
  echo "Finish: $(date)"
}

calc_strip_components() {
  if [ $# -lt 2 ];then
    echo "usage: calc_strip_components tarfile file_in_rootdir"
  fi
  tar tf $1 | grep $2 | awk -F / 'BEGIN {res=99999}; {if (NF<res) res=NF}; END{print res-1}'
}

toupper() {
  echo $@ | tr '[a-z]' '[A-Z]'
}

tolower() {
  echo $@ | tr '[A-Z]' '[a-z]'
}

capitalize() {
  echo $@ | awk '{ print toupper(substr($0, 1, 1)) substr($0, 2, length($0) - 1) }'
}

finish_test() {
  echo # emptyline
  if [ $# = 1 ]; then
    if [ $1 != 0 ]; then
      echo "Test Failed."
    else
      echo "Test Passed."
    fi
  fi
}

is_macos() {
  test $(uname -s | cut -d' ' -f1) = "Darwin"
}

# https://qiita.com/opiliones/items/e6d75237bf8650313c56
pipefail() {
  local cmd= i=1 ret1 ret2
  pipe_parse "$@" || {
    eval "$cmd"
    return
  }

  exec 4>&1

  ret1=$(
    exec 3>&1
    {
      eval "$cmd" 3>&-
      echo $? >&3
    } 4>&- | {
      shift $i
      pipefail "$@"
    } 3>&- >&4 4>&-
  )
  ret2=$?

  exec 4>&-
  [ $ret2 -ne 0 ] && \
    return $ret2 || return $ret1
}

pipe_parse() {
  [ "$1" = '|' ] && return

  cmd="$cmd \${$i}"
  i=$((i+1))
  shift
  [ $# -gt 0 ] && pipe_parse "$@"
}
