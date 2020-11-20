set -u

. $UTIL_SH

for exe in gsl-config; do
  if [ ! -e ${PREFIX}/bin/${exe} ]; then
    echo "Error: ${PREFIX}/bin/${exe} does not exist"
    exit 127
  fi
done
CONFIG=${PREFIX}/bin/gsl-config

check ${CC:-gcc} -o version $(${CONFIG} --cflags) $(${CONFIG} --libs) version.c
check ./version >/dev/null
res=$(./version)

check test "_$res" = "_${__VERSION__}"
