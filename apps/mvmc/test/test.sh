set -u

. $SCRIPT_DIR/../../scripts/util.sh

for exe in vmcdry.out vmc.out; do
  if [ ! -x ${PREFIX}/bin/$exe ]; then
    echo "Error: ${PREFIX}/bin/${exe} does not exist"
    exit 127
  fi
done

check ${MPIEXEC_CMD} vmc.out -s stdface.def 2>&1
