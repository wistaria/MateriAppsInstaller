#!/bin/sh

SCRIPT_DIR=$(cd "$(dirname $0)"; pwd)
. $SCRIPT_DIR/../util.sh
set_prefix

cat << EOF > $BUILD_DIR/env.sh
export PATH=$PREFIX_TOOL/bin:\$PATH
export LD_LIBRARY_PATH=$PREFIX_TOOL/lib:/usr/lib64:\$LD_LIBRARY_PATH
EOF
$SUDO mkdir -p $PREFIX_TOOL
$SUDO cp -f $BUILD_DIR/env.sh $PREFIX_TOOL
