#!/bin/sh

SCRIPT_DIR=$(cd "$(dirname $0)"; pwd)
. $SCRIPT_DIR/../../scripts/util.sh
. $SCRIPT_DIR/version.sh
set_prefix

URL=https://github.com/pomerol-ed/pomerol/archive/${POMEROL_SHA}.zip
# URL=https://github.com/issp-center-dev/DCore/archive/refs/tags/v${__VERSION__}.tar.gz
ARCHIVE=${SOURCE_DIR}/${__NAME__}-${__VERSION__}.zip

if [ -f $ARCHIVE ]; then :; else
  check wget $URL -O $ARCHIVE
fi
