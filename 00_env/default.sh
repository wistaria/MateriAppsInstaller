#!/bin/sh

SCRIPT_DIR=$(cd "$(dirname $0)"; pwd)
. $SCRIPT_DIR/../util.sh
set_prefix

cat << EOF > $BUILD_DIR/env.sh
export PATH=$PREFIX_TOOL/bin:\$PATH
export LD_LIBRARY_PATH=$PREFIX_TOOL/lib:/usr/lib64:\$LD_LIBRARY_PATH
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
$SUDO mkdir -p $PREFIX_TOOL $PREFIX_TOOL/env.d
$SUDO cp -f $BUILD_DIR/env.sh $PREFIX_TOOL
