set -u

. $UTIL_SH

cp $PREFIX/examples/square/dmft_square.ini .

INPUT=./dmft_square.ini

for exe in dcore dcore_pre dcore_bse dcore_post; do
  if [ ! -e ${PREFIX}/bin/${exe} ]; then
    echo "Error: ${PREFIX}/bin/${exe} does not exist"
    exit 127
  fi
done

cat >> ${INPUT} << EOF

[mpi]
command = "${MPIEXEC} ${MPIEXEC_NPROCS_OPT} #"
EOF

check dcore_pre          ${INPUT}
check dcore --np 2       ${INPUT}
check dcore_check        ${INPUT}
check dcore_post --np 2  ${INPUT}
