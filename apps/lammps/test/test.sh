set -u

. $UTIL_SH

for exe in lmp; do
  if [ ! -e ${PREFIX}/bin/${exe} ]; then
    echo "Error: ${PREFIX}/bin/${exe} does not exist"
    exit 127
  fi
done

cp $PREFIX/share/lammps/examples/micelle/* .

check ${MPIEXEC_CMD} lmp -in in.micelle
