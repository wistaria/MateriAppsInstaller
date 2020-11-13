set -u
set -o pipefail

for exe in ShiftK.out; do
  if [ ! -x ${PREFIX}/bin/$exe ]; then
    echo "Error: ${PREFIX}/bin/${exe} does not exist"
    exit 127
  fi
done

for header in komega.h komega_bicg.mod komega_cg_r.mod komega_cg_c.mod komega_cocg.mod; do
  if [ ! -f ${PREFIX}/include/$header ]; then
    echo "Error: ${PREFIX}/include/${header} does not exist"
    exit 127
  fi
done

for lib in libkomega.a libkomega.so ;do
  if [ ! -f ${PREFIX}/lib/$lib ]; then
    echo "Error: ${PREFIX}/lib/${lib} does not exist"
    exit 127
  fi
done
