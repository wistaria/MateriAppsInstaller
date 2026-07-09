set -u

. $UTIL_SH

# Smoke test for the compiled package: the default (serial + parallel) build
# must have produced and installed the core TurboRVB executables. The serial
# QMC engine, the DFT prep step, and the serial tools are always built; the
# MPI QMC engine is built when an MPI Fortran compiler is available (which the
# full default build requires).
# serial QMC engine, DFT prep and serial tools are always built
for exe in turborvb-serial.x prep-serial.x makefort10.x readalles.x; do
  if [ ! -x ${PREFIX}/bin/$exe ]; then
    echo "Error: ${PREFIX}/bin/${exe} does not exist"
    echo "Installed executables:"
    ls -1 ${PREFIX}/bin 2>/dev/null
    exit 1
  fi
done

# The default build also compiles the parallel (MPI) engine. CMake silently
# drops the parallel targets when no MPI Fortran compiler is found at configure
# time, so a missing turborvb-mpi.x almost always means MPI was unavailable.
if [ ! -x ${PREFIX}/bin/turborvb-mpi.x ]; then
  echo "Error: ${PREFIX}/bin/turborvb-mpi.x does not exist."
  echo "The default build compiles the parallel version; this usually means no"
  echo "MPI Fortran compiler was found at configure time. Install MPI and"
  echo "reinstall (see the TurboRVB README)."
  echo "Installed executables:"
  ls -1 ${PREFIX}/bin 2>/dev/null
  exit 1
fi

echo "turborvb executables OK"
