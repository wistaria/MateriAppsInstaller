set -u
set -o pipefail

for exe in gcc g++ gfortran; do
  if [ ! -e ${PREFIX}/bin/${exe} ]; then
    echo "Error: ${PREFIX}/bin/${exe} does not exist"
    exit 127
  fi
done

${PREFIX}/bin/g++ hello.cpp -o hello
./hello
