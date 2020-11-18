. $UTIL_SH
set_prefix

export TESTDIR=$(cd $(dirname $0); pwd)
check sh ${TESTDIR}/download_pp.sh

for exe in calc_wannier calc_chiqw calc_j3d calc_w3d calc_gw transfer_analysis wfn2respack qe2respack.py xtapp2respack.sh
do
  if [ ! -f ${PREFIX}/bin/${exe} ]; then
    echo "Error: ${PREFIX}/bin/${exe} does not exist"
    exit 127
  fi
done

if [ -z ${PWX} ];then
  echo "Error: PWX is empty"
  exit 127
fi
ret=0
type ${PWX} > /dev/null 2>/dev/null || ret=$?
if [ $ret -ne 0 ]; then
  if [ -f $MA_ROOT/espresso/espressovars.sh ]; then
    . $MA_ROOT/espresso/espressovars.sh
  else
    echo "Error: $PWX is not found"
    exit 127
  fi
fi
check ${MPIEXEC_CMD} ${PWX} -in scf.in

check qe2respack.py work/Si.save 2>&1
check calc_wannier < input.in 2>&1
check calc_w3d < input.in 2>&1
check calc_j3d < input.in 2>&1
check ${MPIEXEC_CMD} calc_chiqw < input.in 2>&1
