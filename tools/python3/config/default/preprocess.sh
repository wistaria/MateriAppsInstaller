if [ -n "$OPENSSL_ROOT" ]; then
  ./configure \
    --prefix=$PREFIX \
    --enable-shared \
    --with-openssl=${OPENSSL_ROOT} \
    --enable-optimizations
else
  ./configure \
    --prefix=$PREFIX \
    --enable-shared \
    --enable-optimizations
fi
