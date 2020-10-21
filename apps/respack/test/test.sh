set -o pipefail

for exe in calc_wannier calc_chiqw calc_j3d calc_w3d calc_gw transfer_analysis wfn2respack qe2respack.py xtapp2respack.sh
do
  if [ ! -f ${PREFIX}/bin/${exe} ]; then
    echo "Error: ${PREFIX}/bin/${exe} does not exist"
    exit 127
  fi
done

set -e

${MPIEXEC_CMD} ${PWX} -in scf.in | tee scf.out || exit 127

qe2respack.py work/Si.save 2>&1 | tee -a log || exit 127
calc_wannier < input.in 2>&1 | tee -a log || exit 127
calc_w3d < input.in 2>&1 | tee -a log || exit 127
calc_j3d < input.in 2>&1 | tee -a log || exit 127
${MPIEXEC_CMD} calc_chiqw < input.in 2>&1 | tee -a log || exit 127
