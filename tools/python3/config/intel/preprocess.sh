set -u

test -z ${CC+defined} && CC=icc
test -z ${CXX+defined} && CXX=icpc
test -z ${FC+defined} && FC=ifort

if [ -n ${LIBFFI_ROOT+defined} ]; then
  CPPFLAGS="-I${LIBFFI_ROOT}/include $CPPFLAGS"
  LDFLAGS="-L${LIBFFI_ROOT}/lib64 -L${LIBFFI_ROOT}/lib $LDFLAGS"
fi
if [ -n ${ZLIB_ROOT+defined} ]; then
  CPPFLAGS="-I${ZLIB_ROOT}/include $CPPFLAGS"
  LDFLAGS="-L${ZLIB_ROOT}/lib $LDFLAGS"
fi
if [ -n ${OPENSSL_ROOT+defined} ]; then
  OPENSSL_FLAGS="--with-openssl=${OPENSSL_ROOT}"
fi

if [ -n ${TCLTK_ROOT+defined} ]; then
  TCL_LIB=$(. ${TCLTK_ROOT}/lib/tclConfig.sh; echo ${TCL_LIB_FLAG})
  TK_LIB=$(. ${TCLTK_ROOT}/lib/tkConfig.sh; echo ${TK_LIB_FLAG})
  ./configure CC="$CC" CXX="$CXX" FC="$FC" AR=xiar CFLAGS="-fwrapv" CPPFLAGS="$CPPFLAGS" LDFLAGS="$LDFLAGS" --prefix=$PREFIX --enable-shared --enable-optimizations --with-system-ffi $OPENSSL_FLAGS --with-tcltk-includes="-I${TCLTK_ROOT}/include" --with-tcltk-libs="-L${TCLTK_ROOT}/lib $TCL_LIB $TK_LIB"
else
  ./configure CC="$CC" CXX="$CXX" FC="$FC" AR=xiar CFLAGS="-fwrapv" CPPFLAGS="$CPPFLAGS" LDFLAGS="$LDFLAGS" --prefix=$PREFIX --enable-shared --enable-optimizations --with-system-ffi $OPENSSL_FLAGS
fi
