set -u

for exe in python3 pip3; do
  if [ ! -e ${PREFIX}/bin/${exe} ]; then
    echo "Error: ${PREFIX}/bin/${exe} does not exist"
    exit 127
  fi
done

python3 -c 'import numpy' || exit 127
python3 -c 'import scipy' || exit 127
python3 -c 'import matplotlib' || exit 127
