#!/bin/sh

set_prefix() {
  PREFIX_OPT_DEF="$HOME/opt"
  PREFIX_ALPS_DEF="$HOME/alps"
  PREFIX_ROKKO_DEF="$HOME/rokko"
  SUDO=

  hostname -f > /dev/null 2>&1
  if [ $? = 0 ]; then
    HOSTNAME=$(hostname -f)
  else
    HOSTNAME=$(hostname)
  fi

  if [ -d /opt/nano/alps ]; then
    if [ -d /opt/local ]; then
      PREFIX_OPT_DEF="/opt/local"
      PREFIX_ALPS_DEF="/opt/nano/alps"
      SUDO="sudo"
    else
      PREFIX_OPT_DEF="/opt/nano/alps"
      PREFIX_ALPS_DEF="/opt/nano/alps"
    fi
  fi

  # for Mac OS X
  if [ $(uname) = Darwin ]; then
    if [ -d /opt/alps ]; then
      if [ -d /opt/rokko ]; then
        PREFIX_OPT_DEF="/opt/alps"
        PREFIX_ALPS_DEF="/opt/alps"
        PREFIX_ROKKO_DEF="/opt/rokko"
      fi
    fi
  fi

  # for camphor.kudpc.kyoto-u.ac.jp
  if [ -d /LARGE0/hp120237 ]; then
    PREFIX_OPT_DEF="/LARGE0/hp120237/opt"
    PREFIX_ALPS_DEF="/LARGE0/hp120237/alps"
  fi

  # for k.aics.riken.jp
  if [ -d /opt/spire/alps ]; then
    PREFIX_OPT_DEF="/opt/spire/alps"
    PREFIX_ALPS_DEF="/opt/spire/alps"
  fi

  # for kashiwa.issp.u-tokyo.ac.jp
  if [ -d /home/issp/materiapps ]; then
    PREFIX_OPT_DEF="/home/issp/materiapps/opt"
    PREFIX_ALPS_DEF="/home/issp/materiapps/alps"
  fi

  # for maki.issp.u-tokyo.ac.jp
  if [[ ! -z `echo "$HOSTNAME" | egrep "^maki.\.fx10hpc$"` ]]; then
    PREFIX_OPT_DEF="/global/app/materiapps/opt"
    PREFIX_ALPS_DEF="/global/app/materiapps/alps"
  fi

  # for oakleaf-fx.cc.u-tokyo.ac.jp
  if [[ ! -z `echo "$HOSTNAME" | egrep "^oakleaf-fx.*$"` ]]; then
    PREFIX_OPT_DEF="/group/gc25/share/opt"
    PREFIX_ALPS_DEF="/group/gc25/share/alps"
  fi

  if [ -z "$PREFIX_OPT" ]; then
    PREFIX_OPT="$PREFIX_OPT_DEF"
  fi
  if [ -z "$PREFIX_ALPS" ]; then
    PREFIX_ALPS="$PREFIX_ALPS_DEF"
  fi
  if [ -z "$PREFIX_ROKKO" ]; then
    PREFIX_ROKKO="$PREFIX_ROKKO_DEF"
  fi
  echo "PREFIX_OPT = $PREFIX_OPT"
  echo "PREFIX_ALPS = $PREFIX_ALPS"
  echo "PREFIX_ROKKO = $PREFIX_ROKKO"
  echo "SUDO = $SUDO"
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

start_info() {
  echo "Start: $(date) on $(hostname)"
}

finish_info() {
  echo "Finish: $(date)"
}
