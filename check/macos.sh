#!/bin/sh

ENV_CONF="default"
TOOL_SET="
11_eigen3:default
25_boost:macos
40_alpscore:default_cxx1y
70_alps:macos
78_hphi:macos
"

SCRIPT_DIR=$(cd "$(dirname $0)"; pwd)
MAINSTALLER_CONFIG=$HOME/.mainstaller-check
PREFIX=$HOME/materiapps-check
BUILD_DIR=$PREFIX/build

mkdir -p $PREFIX $BUILD_DIR
cat << EOF > $MAINSTALLER_CONFIG
PREFIX=$PREFIX
BUILD_DIR=$BUILD_DIR
EOF

###

export MAINSTALLER_CONFIG
sh $SCRIPT_DIR/../00_env/$ENV_CONF.sh
for s in $TOOL_SET; do
  dirc=$(echo $s | cut -d: -f1)
  tool=$(echo $dirc | sed 's/^[0-9][0-9]_//')
  conf=$(echo $s | cut -d: -f2)
  if [ -d $PREFIX/$tool ]; then :; else
    echo "[$dirc, $tool, $conf]"
    sh $SCRIPT_DIR/../$dirc/$conf.sh && sh $SCRIPT_DIR/../$dirc/link.sh
  fi
done

###

source $PREFIX/env.sh
check_maversion
