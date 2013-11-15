#!/bin/sh

# defines PREFIX_OPT, PREFIX_ALPS

UNAME=`uname`
HOST=`hostname -f`

PREFIX_OPT_DEF="$HOME/opt"
PREFIX_ALPS_DEF="$HOME/alps"

# Mac OS X
if [ "$UNAME" = Darwin ]; then
  if [ -d /opt/alps ]; then
    PREFIX_OPT_DEF="/opt/alps"
    PREFIX_ALPS_DEF="/opt/alps"
  fi
fi

# k.aics.riken.jp
if [[ "$HOST" =~ fe01p.*\.k ]]; then
  PREFIX_OPT_DEF="/data/share002/opt"
  PREFIX_ALPS_DEF="/data/share002/alps"
fi

# maki.issp.u-tokyo.ac.jp
if [[ "$HOST" =~ maki.\.fx10hpc ]]; then
  PREFIX_OPT_DEF="/global/nano/alps"
  PREFIX_ALPS_DEF="/global/nano/alps"
fi

# phi.aics.riken.jp
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

if [ -n "$PREFIX_OPT" ]; then
    echo "PREFIX_OPT = $PREFIX_OPT"
else
    echo "PREFIX_OPT = undefined"
fi
if [ -n "$PREFIX_ALPS" ]; then
    echo "PREFIX_ALPS = $PREFIX_ALPS"
else
    echo "PREFIX_ALPS = undefined"
fi
