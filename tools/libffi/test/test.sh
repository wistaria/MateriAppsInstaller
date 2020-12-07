set -u

. $UTIL_SH

check ${CC:-gcc} -o check -I${PREFIX}/include -L${PREFIX}/lib64 -L${PREFIX}/lib check.c -lffi
