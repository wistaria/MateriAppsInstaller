#!/bin/sh

SCRIPT_DIR=$(cd "$(dirname $0)"; pwd)
. $SCRIPT_DIR/../util.sh
. $SCRIPT_DIR/version.sh
set_prefix

. $PREFIX_TOOL/env.sh

<<<<<<< HEAD
HPHIVARS_SH=$PREFIX_APPS/HPhi/HPhivars-$HPHI_VERSION-$HPHI_PATCH_VERSION.sh
rm -f $PREFIX_APPS/HPhi/HPhivars.sh
ln -s $HPHIVARS_SH $PREFIX_APPS/HPhi/HPhivars.sh
=======
HPHIVARS_SH=$PREFIX_APPS/HPhi/HPhivars-$HPHI_VERSION-$HPHI_MA_REVISION.sh
$SUDO_APPS rm -f $PREFIX_APPS/HPhi/HPhivars.sh
$SUDO_APPS ln -s $HPHIVARS_SH $PREFIX_APPS/HPhi/HPhivars.sh
>>>>>>> c2b4d0891e316167ba37a8cd19676f1cfc8c0d54

