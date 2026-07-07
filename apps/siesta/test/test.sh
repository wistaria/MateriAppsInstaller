set -u
set -e

. $UTIL_SH

if [ ! -x ${PREFIX}/bin/siesta ]; then
  echo "Error: ${PREFIX}/bin/siesta does not exist"
  exit 1
fi

siesta --version

cp ${PREFIX}/share/examples/H2O/h2o.fdf \
   ${PREFIX}/share/examples/H2O/H.psf \
   ${PREFIX}/share/examples/H2O/O.psf .

${MPIEXEC_CMD} siesta h2o.fdf > h2o.out 2>&1 || { tail -30 h2o.out; exit 1; }

grep -q "End of run" h2o.out

# reference total energy for the bundled H2O example (eV); identical
# results were obtained with gcc/OpenBLAS (macOS) and ifort/MKL (ohtaka)
EREF=-466.104493
ETOT=$(awk '/siesta:.*Total =/{v=$NF} END{print v}' h2o.out)
echo "Total energy: ${ETOT} eV (reference: ${EREF} eV)"
awk -v e="$ETOT" -v r="$EREF" 'BEGIN { d=e-r; if (d<0) d=-d; exit !(d<1e-3) }'
