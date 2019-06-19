#!/bin/sh

SCRIPT_DIR=$(cd "$(dirname $0)"; pwd)
. $SCRIPT_DIR/../util.sh
. $SCRIPT_DIR/version.sh
set_prefix

cd $BUILD_DIR
if [ -d dsqss-v$DSQSS_VERSION ]; then :; else
  check mkdir -p dsqss-v$DSQSS_VERSION
  if [ -f $SOURCE_DIR/dsqss-v$DSQSS_VERSION.tar.gz ]; then
    cd dsqss-v$DSQSS_VERSION
    check tar zxf $SOURCE_DIR/dsqss-v$DSQSS_VERSION.tar.gz --strip-components=1
  else
    if [ -f dsqss-$DSQSS_VERSION.tar.gz ]; then :; else
      check wget https://github.com/issp-center-dev/dsqss/archive/v${DSQSS_VERSION}.tar.gz -O dsqss-v${DSQSS_VERSION}.tar.gz
    fi
    cd dsqss-v${DSQSS_VERSION}
    check tar zxf $BUILD_DIR/dsqss-v${DSQSS_VERSION}.tar.gz --strip-components=1
  fi
  for lang in jp en; do
    check wget https://issp-center-dev.github.io/dsqss/manual/v${DSQSS_VERSION}/${lang}/DSQSS-v${DSQSS_VERSION}.pdf -O DSQSS_${lang}.pdf
  done
fi
