#!/bin/sh

SCRIPT_DIR=$(cd "$(dirname $0)"; pwd)
. $SCRIPT_DIR/../util.sh
. $SCRIPT_DIR/version.sh
set_prefix

. $PREFIX_TOOL/env.sh

QUANTUM_ESPRESSOVARS_SH=$PREFIX_APPS/quantum-espresso/quantum-espressovars-$QUANTUM_ESPRESSO_VERSION-$QUANTUM_ESPRESSO_MA_REVISION.sh
rm -f $PREFIX_APPS/quantum-espresso/quantum-espressovars.sh
ln -s $QUANTUM_ESPRESSOVARS_SH $PREFIX_APPS/quantum-espresso/quantum-espressovars.sh
