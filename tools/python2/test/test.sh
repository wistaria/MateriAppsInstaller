set -u

for exe in python2 pip2; do
  if [ ! -e ${PREFIX}/bin/${exe} ]; then
    echo "Error: ${PREFIX}/bin/${exe} does not exist"
    exit 127
  fi
done

python2 -c 'import numpy' || exit 127
python2 -c 'import scipy' || exit 127
python2 -c 'import matplotlib' || exit 127
