set -u
set -e

. $SCRIPT_DIR/../../scripts/util.sh

for exe in tenes_simple tenes_std tenes; do
  if [ ! -x ${PREFIX}/bin/$exe ]; then
    echo "Error: ${PREFIX}/bin/${exe} does not exist"
    exit 1
  fi
done

tenes_simple simple.toml
tenes_std std.toml
check ${MPIEXEC_CMD} tenes input.toml
