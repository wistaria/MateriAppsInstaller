if [ ! -f makefile.org ]; then
  sed \
  -e 's/^\s*\(CC\s*=\)/# \1/' \
  -e 's/^\s*\(FC\s*=\)/# \1/' \
  -e 's/^\s*\(LIB\s*=\)/# \1/' \
  -e 's/^\s*\(MKLROOT\s*=\)/# \1/' \
  makefile > makefile.org
fi
