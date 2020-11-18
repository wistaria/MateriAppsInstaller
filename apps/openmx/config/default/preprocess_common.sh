if [ ! -f makefile.org ]; then
  sed \
  -e 's/^[ ]*\(CC[ ]*=\)/# \1/' \
  -e 's/^[ ]*\(FC[ ]*=\)/# \1/' \
  -e 's/^[ ]*\(LIB[ ]*=\)/# \1/' \
  -e 's/^[ ]*\(MKLROOT[ ]*=\)/# \1/' \
  makefile > makefile.org
fi
