set -u

. $UTIL_SH

for exe in HPhi; do
  if [ ! -e ${PREFIX}/bin/${exe} ]; then
    echo "Error: ${PREFIX}/bin/${exe} does not exist"
    exit 127
  fi
done

check ${MPIEXEC_CMD} HPhi -s stdface.def
