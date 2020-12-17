#!/bin/sh

TOOLS="boost:macos eigen3:default"
APPS="alps:macos dsqss:gcc espresso:default hphi:gcc mvmc:gcc"

TOP_DIR=$(cd "$(dirname $0)"; cd ..; pwd)

sh $TOP_DIR/setup/setup.sh

for tool in $TOOLS; do
  name=$(echo $tool | cut -d: -f1)
  conf=$(echo $tool | cut -d: -f2)
  sh $TOP_DIR/tools/$name/install.sh $conf
  sh $TOP_DIR/tools/$name/link.sh
done

for app in $APPS; do
  name=$(echo $app | cut -d: -f1)
  conf=$(echo $app | cut -d: -f2)
  sh $TOP_DIR/apps/$name/install.sh $conf
  sh $TOP_DIR/apps/$name/link.sh
done

for tool in $TOOLS; do
  name=$(echo $tool | cut -d: -f1)
  conf=$(echo $tool | cut -d: -f2)
  bash $TOP_DIR/tools/$name/runtest.sh
done

for app in $APPS; do
  name=$(echo $app | cut -d: -f1)
  conf=$(echo $app | cut -d: -f2)
  bash $TOP_DIR/apps/$name/runtest.sh
done
