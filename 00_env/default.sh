#!/bin/sh

SCRIPT_DIR=$(cd "$(dirname $0)"; pwd)
. $SCRIPT_DIR/../util.sh
. $SCRIPT_DIR/version.sh
set_prefix

sh $SCRIPT_DIR/install_cm.sh

cat << EOF > $BUILD_DIR/env.sh
# env $(basename $0 .sh) $ENV_VERSION $ENV_MA_REVISION $(date +%Y%m%d-%H%M%S)
export MA_ROOT_TOOL=$PREFIX_TOOL
export MA_ROOT_APPS=$PREFIX_APPS
export PATH=$PREFIX_TOOL/bin:\$PATH
export LD_LIBRARY_PATH=$PREFIX_TOOL/lib:\$LD_LIBRARY_PATH
unset i
for i in $PREFIX_TOOL/env.d/*.sh ; do
  if [ -r "\$i" ]; then
    if [ "\${-#*i}" != "\$-" ]; then
      . "\$i"
    else
      . "\$i" >/dev/null 2>&1
    fi
  fi
done
unset i
EOF

mkdir -p $PREFIX_TOOL/env.d $PREFIX_TOOL/lib
rm -f $PREFIX_TOOL/env.sh $PREFIX_TOOL/env-cxx03.sh $PREFIX_TOOL/env-cxx1y.sh
cp -f $BUILD_DIR/env.sh $PREFIX_TOOL/
rm -f $BUILD_DIR/env.sh
