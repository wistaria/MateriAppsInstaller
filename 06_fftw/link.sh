#!/bin/sh

SCRIPT_DIR=$(cd "$(dirname $0)"; pwd)
. $SCRIPT_DIR/../util.sh
. $SCRIPT_DIR/version.sh
set_prefix

. $PREFIX_TOOL/env.sh

FFTWVARS_SH=$PREFIX_TOOL/fftw/fftwvars-$FFTW_VERSION-$FFTW_PATCH_VERSION.sh
$SUDO_TOOL rm -f $PREFIX_TOOL/env.d/fftwvars.sh
$SUDO_TOOL ln -s $FFTWVARS_SH $PREFIX_TOOL/env.d/fftwvars.sh
