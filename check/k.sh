#!/bin/sh

ENV_CONF="fx10"
TOOL_SET="
04_cmake:fx10
05_lapack:fx10
10_hdf5:fx10
20_python:fx10
21_python3:fx10
25_boost:fx10
35_git:fx10
70_alps:fx10
78_hphi:fx10
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
