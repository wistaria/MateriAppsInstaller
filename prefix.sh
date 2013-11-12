#!/bin/sh

# defines PREFIX_OPT, PREFIX_ALPS

UNAME=`uname`
HOST=`hostname -f`

# Mac OS X
if [ "$UNAME" = Darwin ]; then
  if [ -d /opt/alps ]; then
    PREFIX_ALPS_DEF="/opt/alps"
  else
    PREFIX_ALPS_DEF="$HOME/alps"
  fi
fi

# phi.aics.riken.jp
if [[ "$HOST" = phi ]]; then
  PREFIX_OPT_DEF="/opt/local"
  PREFIX_ALPS_DEF="/opt/nano/alps"
fi

# tatara.cc.kyushu-u.ac.jp
if [[ "$HOST" =~ sugoka.*\.qdai\.hpc ]]; then
  PREFIX_OPT_DEF="$HOME/opt"
  PREFIX_ALPS_DEF="$HOME/alps"
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
