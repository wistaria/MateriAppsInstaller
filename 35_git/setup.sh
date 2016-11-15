#!/bin/sh

SCRIPT_DIR=$(cd "$(dirname $0)"; pwd)
. $SCRIPT_DIR/../util.sh
set_prefix
. $PREFIX_TOOL/env.sh
. $SCRIPT_DIR/version.sh

cd $BUILD_DIR
if [ -d git-$GIT_VERSION ]; then :; else
  if [ -f $HOME/source/git-$GIT_VERSION.tar.gz ]; then
    check tar zxf $HOME/source/git-$GIT_VERSION.tar.gz
  else
    check wget ftp://www.kernel.org/pub/software/scm/git/git-$GIT_VERSION.tar.gz
    check tar zxf git-$GIT_VERSION.tar.gz
  fi
fi
