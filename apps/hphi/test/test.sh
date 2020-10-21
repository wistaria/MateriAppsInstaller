set -u
set -o pipefail

for exe in HPhi; do
  if [ ! -f ${PREFIX}/bin/${exe} ]; then
    echo "Error: ${PREFIX}/bin/${exe} does not exist"
    exit 127
  fi
done

${MPIEXEC_CMD} HPhi -s stdface.def | tee log || exit 127
