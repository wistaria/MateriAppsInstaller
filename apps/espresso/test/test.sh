set -u
set -o pipefail

for exe in pw.x bands.x; do
  if [ ! -f ${PREFIX}/bin/${exe} ]; then
    echo "Error: ${PREFIX}/bin/${exe} does not exist"
    exit 127
  fi
done

${MPIEXEC_CMD} pw.x -in scf.in | tee scf.out || exit 127
