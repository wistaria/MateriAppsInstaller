set -u

$SCRIPT_DIR/../../tools/zlib/find.sh

if [ -n "$ZLIB_ROOT" ]; then
  ./configure --prefix=$PREFIX --with-tcltk --with-zlib=$ZLIB_ROOT
else
  ./configure --prefix=$PREFIX --with-tcltk
fi
