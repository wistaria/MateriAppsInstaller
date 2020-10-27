set -u
set -o pipefail

for exe in dla pmwa_H pmwa_B; do
  if [ ! -x ${PREFIX}/bin/$exe ]; then
    echo "Error: ${PREFIX}/bin/${exe} does not exist"
    exit 127
  fi
done

cd dla
dla_pre std.toml
${MPIEXEC_CMD} dla param.in 2>&1 | tee -a ../log || exit 127
echo test for dla finished | tee -a ../log
cd ..

cd pmwa
pmwa_pre std.in
${MPIEXEC_CMD} pmwa_H param.in 2>&1 | tee -a ../log  exit 127
echo test for pmwa finished | tee -a ../log
cd ..
