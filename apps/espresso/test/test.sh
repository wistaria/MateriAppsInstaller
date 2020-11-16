set -u

sh ./download_pp.sh

. $SCRIPT_DIR/../../scripts/util.sh

for exe in pw.x bands.x; do
  if [ ! -f ${PREFIX}/bin/${exe} ]; then
    echo "Error: ${PREFIX}/bin/${exe} does not exist"
    exit 127
  fi
done

check ${MPIEXEC_CMD} pw.x -in scf.in
