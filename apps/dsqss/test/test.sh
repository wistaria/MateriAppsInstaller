set -u

. $UTIL_SH

for exe in dla pmwa_H pmwa_B; do
  if [ ! -x ${PREFIX}/bin/$exe ]; then
    echo "Error: ${PREFIX}/bin/${exe} does not exist"
    exit 127
  fi
done

cd dla
dla_pre std.toml
check ${MPIEXEC_CMD} dla param.in 2>&1
echo test for dla finished
cd ..

cd pmwa
pmwa_pre std.in
check ${MPIEXEC_CMD} pmwa_H param.in 2>&1
echo test for pmwa finished
cd ..
