#!/bin/sh

ENV_CONF="default"

TOOL="
11_eigen3:default
11_komega:default
25_boost:macos
40_alpscore:default
"

APPS="
70_alps:macos
71_xtapp:macos
83_triqs:default
84_alpscore-cthyb:default
86_dcore:default
"

# APPS="
# 70_alps:macos
# 71_xtapp:macos
# 72_espresso:default
# 72_openmx:macos
# 75_gromacs:macos
# 75_lammps:default
# 77_dsqss:default
# 78_hphi:macos
# 79_mvmc:default
# 80_tapioca:macos
# 83_triqs:default
# 84_alpscore-cthyb:default
# 86_dcore:default
# "

SCRIPT_DIR=$(cd "$(dirname $0)"; pwd)
. $SCRIPT_DIR/../util.sh
set_prefix
print_prefix

echo "[00_env, env, $ENV_CONF]"
sh $SCRIPT_DIR/../00_env/$ENV_CONF.sh

for s in $TOOL; do
  dirc=$(echo $s | cut -d: -f1)
  tool=$(echo $dirc | sed 's/^[0-9][0-9]_//')
  conf=$(echo $s | cut -d: -f2)
  echo "[$dirc, $tool, $conf]"
  sh $SCRIPT_DIR/../$dirc/$conf.sh && sh $SCRIPT_DIR/../$dirc/link.sh
done

for s in $APPS; do
  dirc=$(echo $s | cut -d: -f1)
  app=$(echo $dirc | sed 's/^[0-9][0-9]_//')
  conf=$(echo $s | cut -d: -f2)
  echo "[$dirc, $app, $conf]"
  sh $SCRIPT_DIR/../$dirc/$conf.sh && sh $SCRIPT_DIR/../$dirc/link.sh
done
