set -u

. $UTIL_SH

check ${CC:-gcc} -o version -I${PREFIX}/include -L${PREFIX}/lib version.c -lz
check ./version
