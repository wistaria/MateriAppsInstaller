#!/bin/sh

SCRIPT_DIR=$(cd "$(dirname $0)"; pwd)
. $SCRIPT_DIR/../util.sh
. $SCRIPT_DIR/version.sh
set_prefix

. $PREFIX_TOOL/env.sh

QT4VARS_SH=$PREFIX_TOOL/qt4/qt4vars-$QT4_VERSION-$QT4_PATCH_VERSION.sh
$SUDO_TOOL rm -f $PREFIX_TOOL/env.d/qt4vars.sh
$SUDO_TOOL ln -s $QT4VARS_SH $PREFIX_TOOL/env.d/qt4vars.sh
