if [ -n "$OPENSSL_ROOT" ]; then
  ./configure \
    CFLAGS="-I${OPENSSL_ROOT}/include $CFLAGS" \
    LIBS="-L${OPENSSL_ROOT}/lib -lssl $LIBS" \
    --prefix=$PREFIX \
    --enable-shared \
    --enable-optimizations
else
  ./configure \
    --prefix=$PREFIX \
    --enable-shared \
    --enable-optimizations
fi
