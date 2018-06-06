#!/bin/sh

SCRIPT_DIR=$(cd "$(dirname $0)"; pwd)
. $SCRIPT_DIR/../util.sh
set_prefix
. $PREFIX_TOOL/env.sh

. $SCRIPT_DIR/version.sh
BOOSTVARS_SH=$PREFIX_TOOL/boost/boostvars-$BOOST_VERSION_DOTTED-$BOOST_MA_REVISION.sh
if [ -f $BOOSTVARS_SH ]; then
  rm -f $PREFIX_TOOL/env.d/boostvars.sh
  ln -s $BOOSTVARS_SH $PREFIX_TOOL/env.d/boostvars.sh
else
  . $SCRIPT_DIR/version-fx10.sh
  BOOSTVARS_SH=$PREFIX_TOOL/boost/boostvars-$BOOST_VERSION_DOTTED-$BOOST_MA_REVISION.sh
  if [ -f $BOOSTVARS_SH ]; then
    rm -f $PREFIX_TOOL/env.d/boostvars.sh
    ln -s $BOOSTVARS_SH $PREFIX_TOOL/env.d/boostvars.sh
  else
    echo "Error: boost not installed"
    exit 127
  fi
fi
