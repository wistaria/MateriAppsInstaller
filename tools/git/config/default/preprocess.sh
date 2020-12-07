set -u

. $SCRIPT_DIR/../../tools/zlib/find.sh

if [ ${ZLIB_ROOT:-no} = "no" ]; then
  ./configure --prefix=$PREFIX --with-tcltk
else
  ./configure --prefix=$PREFIX --with-tcltk --with-zlib=$ZLIB_ROOT
fi
