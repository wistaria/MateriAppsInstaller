#!/bin/sh

set_prefix() {
  MAINSTALLER_CONFIG_DEF="$HOME/.mainstaller"
  PREFIX_DEF="$HOME/materiapps"
  BUILD_DIR_DEF="$HOME/build"
  SOURCE_DIR_DEF="$HOME/source"
  MALIVE_REPOSITORY_DEF="http://download.sourceforge.net/project/materiappslive/Debian/archive/wheezy"

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

  if [ -z "$PREFIX_TOOL" ]; then
    if [ -z "$PREFIX" ]; then
      PREFIX_TOOL="$PREFIX_DEF"
    else
      PREFIX_TOOL="$PREFIX"
    fi
  fi
  if [ -z "$PREFIX_APPS" ]; then
    if [ -z "$PREFIX" ]; then
      PREFIX_APPS="$PREFIX_DEF"
    else
      PREFIX_APPS="$PREFIX"
    fi
  fi
  echo "PREFIX_TOOL=$PREFIX_TOOL"
  echo "PREFIX_APPS=$PREFIX_APPS"
  if [ -d "$PREFIX_TOOL" ]; then :; else
    echo "Fatal: target directory $PREFIX_TOOL does not exist!"
    exit 127
  fi
  if [ -d "$PREFIX_APPS" ]; then :; else
    echo "Fatal: target directory $PREFIX_APPS does not exist!"
    exit 127
  fi

  if [ -z "$BUILD_DIR" ]; then
    BUILD_DIR="$BUILD_DIR_DEF"
  fi
  echo "BUILD_DIR=$BUILD_DIR"
  if [ -d "$BUILD_DIR" ]; then :; else
    echo "Fatal: target directory $BUILD_DIR does not exist!"
    exit 127
  fi
  RES=$(touch $BUILD_DIR/.mainstaller.tmp > /dev/null 2>&1; echo $?; rm -f $BUILD_DIR/.mainstaller.tmp)
  if [ $RES = 0 ]; then :; else
    echo "Fatal: have no permission to write in build directory $BUILD_DIR"
    exit 127
  fi

  if [ -z "$SOURCE_DIR" ]; then
    SOURCE_DIR="$SOURCE_DIR_DEF"
  fi
  echo "SOURCE_DIR=$SOURCE_DIR"

  if [ -z "$MALIVE_REPOSITORY" ]; then
    MALIVE_REPOSITORY="$MALIVE_REPOSITORY_DEF"
  fi
  echo "MALIVE_REPOSITORY=$MALIVE_REPOSITORY"

  echo "WGET_OPTION=$WGET_OPTION"

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

start_info() {
  echo "Start: $(date) on $(hostname)"
}

finish_info() {
  echo "Finish: $(date)"
}
