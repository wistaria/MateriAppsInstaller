set -u

. $UTIL_SH

# Smoke test: the two main ALAMODE programs and the auxiliary tools must have
# been built and installed. ALAMODE has no CMake install target for the
# executables, so install.sh copies them by hand; this checks that copy.
for exe in alm anphon; do
  if [ ! -x ${PREFIX}/bin/$exe ]; then
    echo "Error: ${PREFIX}/bin/${exe} does not exist"
    echo "Installed bin:"
    ls -1 ${PREFIX}/bin 2>/dev/null
    exit 1
  fi
done

for tool in analyze_phonons dfc2 fc_virtual parse_fcsxml qe2alm; do
  if [ ! -x ${PREFIX}/tools/$tool ]; then
    echo "Error: ${PREFIX}/tools/${tool} does not exist"
    echo "Installed tools:"
    ls -1 ${PREFIX}/tools 2>/dev/null
    exit 1
  fi
done

echo "alamode executables OK"
