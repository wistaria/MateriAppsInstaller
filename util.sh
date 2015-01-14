#!/bin/sh

set_prefix() {
  PREFIX_DEF="$HOME/materiapps"
  BUILD_DIR_DEF="$HOME/build"
  SUDO_DEF="/usr/bin/sudo"

  if [ -f "$HOME/.mainstaller" ]; then
    source $HOME/.mainstaller
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
  if [ -z "$BUILD_DIR" ]; then
    BUILD_DIR="$BUILD_DIR_DEF"
  fi

  echo "PREFIX_TOOL = $PREFIX_TOOL"
  echo "PREFIX_APPS = $PREFIX_APPS"
  if [ -d "$PREFIX_TOOL" ]; then :; else
    echo "Fatal: target directory $PREFIX_TOOL does not exist!"
    exit 127
  fi
  if [ -d "$PREFIX_APPS" ]; then :; else
    echo "Fatal: target directory $PREFIX_APPS does not exist!"
    exit 127
  fi

  if [ -z "$SUDO" ]; then
    RES=$(touch $PREFIX_TOOL/.mainstaller.tmp > /dev/null 2>&1; echo $?; rm -f $PREFIX_TOOL/.mainstaller.tmp)
    if [ $RES = 0 ]; then
      SUDO_TOOL=
    else
      SUDO_TOOL="$SUDO_DEF"
    fi
    RES=$(touch $PREFIX_APPS/.mainstaller.tmp > /dev/null 2>&1; echo $?; rm -f $PREFIX_APPS/.mainstaller.tmp)
    if [ $RES = 0 ]; then
      SUDO_APPS=
    else
      SUDO_APPS="$SUDO_DEF"
    fi
  else
    SUDO_TOOL="$SUDO"
    SUDO_APPS="$SUDO"
  fi
  echo "SUDO for tool = $SUDO_TOOL"
  echo "SUDO for apps = $SUDO_APPS"

  echo "BUILD_DIR = $BUILD_DIR"
  if [ -d "$BUILD_DIR" ]; then :; else
    echo "Fatal: target directory $BUILD_DIR does not exist!"
    exit 127
  fi
  RES=$(touch $BUILD_DIR/.mainstaller.tmp > /dev/null 2>&1; echo $?; rm -f $BUILD_DIR/.mainstaller.tmp)
  if [ $RES = 0 ]; then :; else
    echo "Fatal: have no permission to write in build directory $BUILD_DIR"
    exit 127
  fi

  return 0
}

set_download_url() {
   MALIVE_REPOSITORY="http://exa.phys.s.u-tokyo.ac.jp/archive/MateriApps/apt/pool"
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
