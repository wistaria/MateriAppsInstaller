#!/bin/sh

# defines PREFIX_OPT, PREFIX_ALPS

UNAME=`uname`
HOST=`hostname -f`

# Mac OS X
if [ "$UNAME" = Darwin ]; then
    if [ -d /opt/alps ]; then
	PREFIX_ALPS="/opt/alps"
    else
	PREFIX_ALPS="$HOME/alps"
    fi
fi

# tatara.cc.kyushu-u.ac.jp
if [[ "$HOST" =~ sugoka*\.qdai\.hpc ]]; then
  :;
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
