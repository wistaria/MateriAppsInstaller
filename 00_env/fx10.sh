#!/bin/sh

SCRIPT_DIR=$(cd "$(dirname $0)"; pwd)
. $SCRIPT_DIR/../util.sh
set_prefix

ENV_VERSION="1.2.0-17-2"

cat << EOF > $BUILD_DIR/env.sh
if [ -f /home/system/Env_base_$ENV_VERSION ]; then
  . /home/system/Env_base_$ENV_VERSION
elif [ -f /work/system/Env_base_$ENV_VERSION ]; then
  . /work/system/Env_base_$ENV_VERSION
fi
export MA_ROOT_TOOL=$PREFIX_TOOL
export MA_ROOT_APPS=$PREFIX_APPS
export PATH=$PREFIX_TOOL/bin:/opt/local/gcc/bin:/opt/local/bin:\$PATH
export LD_LIBRARY_PATH=$PREFIX_TOOL/lib:/opt/local/gcc/lib64:/opt/local/lib:\$LD_LIBRARY_PATH
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
$SUDO_TOOL mkdir -p $PREFIX_TOOL $PREFIX_TOOL/env.d $PREFIX_TOOL/bin
$SUDO_TOOL cp -f $BUILD_DIR/env.sh $PREFIX_TOOL
$SUDO_TOOL cp -f $SCRIPT_DIR/check_maversion $PREFIX_TOOL/bin
$SUDO_TOOL chmod +x $PREFIX_TOOL/bin/check_maversion
