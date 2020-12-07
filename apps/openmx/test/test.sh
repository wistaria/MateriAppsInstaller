set -u

. $UTIL_SH

for exe in openmx; do
  if [ ! -e ${PREFIX}/bin/${exe} ]; then
    echo "Error: ${PREFIX}/bin/${exe} does not exist"
    exit 127
  fi
done

DATAPATH=$(ls -1d ${PREFIX}/DFT_DATA*)

echo DATA.PATH $DATAPATH >> Methane.dat

check ${MPIEXEC_CMD} openmx Methane.dat
