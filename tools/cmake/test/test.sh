set -u
set -o pipefail

for exe in cmake ctest; do
  if [ ! -e ${PREFIX}/bin/${exe} ]; then
    echo "Error: ${PREFIX}/bin/${exe} does not exist"
    exit 127
  fi
done

${PREFIX}/bin/cmake --version || exit 127
