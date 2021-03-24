set -u

test -z ${CPPFLAGS+defined} && CPPFLAGS=
test -z ${LDFLAGS+defined} && LDFLAGS=

if [ ! -z ${LIBFFI_ROOT+defined} ]; then
  CPPFLAGS="-I${LIBFFI_ROOT}/include $CPPFLAGS"
  LDFLAGS="-L${LIBFFI_ROOT}/lib64 -L${LIBFFI_ROOT}/lib $LDFLAGS"
fi
if [ ! -z ${ZLIB_ROOT+defined} ]; then
  CPPFLAGS="-I${ZLIB_ROOT}/include $CPPFLAGS"
  LDFLAGS="-L${ZLIB_ROOT}/lib $LDFLAGS"
fi
if [ ! -z ${OPENSSL_ROOT+defined} ]; then
  OPENSSL_FLAGS="--with-openssl=${OPENSSL_ROOT}"
else
  OPENSSL_FLAGS=
fi

if [ ! -z ${TCLTK_ROOT+defined} ]; then
  TCL_LIB=$(. ${TCLTK_ROOT}/lib/tclConfig.sh; echo ${TCL_LIB_FLAG})
  TK_LIB=$(. ${TCLTK_ROOT}/lib/tkConfig.sh; echo ${TK_LIB_FLAG})
  ./configure CPPFLAGS="$CPPFLAGS" LDFLAGS="$LDFLAGS" --prefix=$PREFIX --enable-shared --enable-optimizations --with-system-ffi $OPENSSL_FLAGS --with-tcltk-includes="-I${TCLTK_ROOT}/include" --with-tcltk-libs="-L${TCLTK_ROOT}/lib $TCL_LIB $TK_LIB"
else
  ./configure CPPFLAGS="$CPPFLAGS" LDFLAGS="$LDFLAGS" --prefix=$PREFIX --enable-shared --enable-optimizations --with-system-ffi $OPENSSL_FLAGS
fi
