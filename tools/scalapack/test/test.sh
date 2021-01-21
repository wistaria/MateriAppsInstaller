set -u

. $UTIL_SH

check ${CC:-gcc} -o check -L${PREFIX}/lib64 -L${PREFIX}/lib check.c -lscalapack
