#!/bin/sh

SCRIPT_DIR=$(cd "$(dirname $0)"; pwd)

MA_HAVE_LIBFFI=no

for cc in cc gcc icc; do __CC__=$(which ${cc}); test -n ${__CC__} && break; done
cat <<EOF > test-$$.c
#include <ffi.h>
int main() { ffi_closure_free((void*)0); }
EOF
${__CC__} test-$$.c -o test-$$ -I${LIBFFI_ROOT}/include -L${LIBFFI_ROOT}/lib -lffi > /dev/null 2>&1
if [ $? = 0 ]; then
  MA_HAVE_LIBFFI=yes
fi
rm -f test-$$.c test-$$

<< "#__COMMENT__"
  echo "MA_HAVE_LIBFFI=${MA_HAVE_LIBFFI}"
#__COMMENT__
