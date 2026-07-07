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

grep "Total =" h2o.out
grep -q "End of run" h2o.out
