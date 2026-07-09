set -u

. $UTIL_SH

# Smoke test for the compiled package: the default (serial + parallel) build
# must have produced and installed the core TurboRVB executables. The serial
# QMC engine, the DFT prep step, and the serial tools are always built; the
# MPI QMC engine is built when an MPI Fortran compiler is available (which the
# full default build requires).
SERIAL_EXES="turborvb-serial.x prep-serial.x makefort10.x readalles.x"
PARALLEL_EXES="turborvb-mpi.x"

for exe in $SERIAL_EXES $PARALLEL_EXES; do
  if [ ! -x ${PREFIX}/bin/$exe ]; then
    echo "Error: ${PREFIX}/bin/${exe} does not exist"
    echo "Installed executables:"
    ls -1 ${PREFIX}/bin 2>/dev/null
    exit 1
  fi
done

echo "turborvb executables OK"
