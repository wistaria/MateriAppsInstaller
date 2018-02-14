#!/bin/sh

SCRIPT_DIR=$(cd "$(dirname $0)"; pwd)
. $SCRIPT_DIR/../util.sh
. $SCRIPT_DIR/version.sh
set_prefix

TOOL=$(ls $SCRIPT_DIR/.. | grep '^[0-6][0-9]_*' | sed 's/^[0-6][0-9]_//')
APPS=$(ls $SCRIPT_DIR/.. | grep '^[7-9][0-9]_*' | sed 's/^[7-9][0-9]_//')

cat << EOF > $BUILD_DIR/check_maversion
#!/bin/sh

TOOL="$TOOL"
APPS="$APPS"

if [ -n "\$MA_ROOT_TOOL" ]; then
  echo "MA_ROOT_TOOL: \$MA_ROOT_TOOL"
  echo "MA_ROOT_APPS: \$MA_ROOT_APPS"
  awk '\$1=="#" && \$2=="env" {print}' "\$MA_ROOT_TOOL/env.sh"
  for t in \$TOOL; do
    if [ -f "\$MA_ROOT_TOOL/env.d/\${t}vars.sh" ]; then
      awk '\$1=="#" && \$2==t {print}' t="\$t" "\$MA_ROOT_TOOL/env.d/\${t}vars.sh"
    fi
  done
  for p in \$APPS; do
    if [ -f "\$MA_ROOT_APPS/\$p/\${p}vars.sh" ]; then
      awk '\$1=="#" && \$2==p {print}' p="\$p" "\$MA_ROOT_APPS/\$p/\${p}vars.sh"
    fi
  done
else
  echo "MateriApps Installation not found."
  exit 127
fi
EOF

$SUDO_TOOL mkdir -p $PREFIX_TOOL/bin
$SUDO_TOOL cp -f $BUILD_DIR/check_maversion $PREFIX_TOOL/bin/
$SUDO_TOOL chmod +x $PREFIX_TOOL/bin/check_maversion
rm -f $BUILD_DIR/check_maversion
