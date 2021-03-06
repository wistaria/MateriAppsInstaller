set -u

for exe in julia; do
  if [ ! -e ${PREFIX}/bin/${exe} ]; then
    echo "Error: ${PREFIX}/bin/${exe} does not exist"
    exit 127
  fi
done

${PREFIX}/bin/julia --version
