#!/bin/sh

SCRIPT_DIR=$(cd "$(dirname $0)"; pwd)
. $SCRIPT_DIR/../util.sh
. $SCRIPT_DIR/version.sh
set_prefix

sh $SCRIPT_DIR/install_cm.sh

cat << EOF > $BUILD_DIR/env-cxx03.sh
# env $(basename $0 .sh) $ENV_VERSION $ENV_MA_REVISION $(date +%Y%m%d-%H%M%S)
export MA_ROOT_TOOL=$PREFIX_TOOL
export MA_ROOT_APPS=$PREFIX_APPS
export MA_CXX_STANDARD=cxx03
export PATH=$PREFIX_TOOL/bin:\$PATH
export LD_LIBRARY_PATH=$PREFIX_TOOL/lib:\$LD_LIBRARY_PATH
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

cat << EOF > $BUILD_DIR/env-cxx1y.sh
# env $(basename $0 .sh) $ENV_VERSION $ENV_MA_REVISION $(date +%Y%m%d-%H%M%S)
export MA_ROOT_TOOL=$PREFIX_TOOL
export MA_ROOT_APPS=$PREFIX_APPS
export MA_CXX_STANDARD=cxx1y
export PATH=$PREFIX_TOOL/bin:\$PATH
export LD_LIBRARY_PATH=$PREFIX_TOOL/lib:\$LD_LIBRARY_PATH
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
cp -f $BUILD_DIR/env-cxx03.sh $BUILD_DIR/env-cxx1y.sh $PREFIX_TOOL/
rm -f $PREFIX_TOOL/env.sh
ln -s env-cxx03.sh $PREFIX_TOOL/env.sh
rm -f $BUILD_DIR/env-cxx03.sh $BUILD_DIR/env-cxx1y.sh
