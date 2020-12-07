make clean

set -e
echo "[make all]"
res=0
make ${MAKE_J} all || res=$?

NOT_INSTALLED=""

if [ $res -ne 0 ]; then
  echo "Failed to make all, exit"
  false
else
  for target in xspectra couple epw gwl w90 gipaw west yambo SternheimerGW plumed d3q; do
    echo ""
    echo "[make $target]"
    res=0
    make ${MAKE_J} $target || res=$?
    if [ $res -ne 0 ]; then
      echo "Failed to make $target"
      NOT_INSTALLED="${NOT_INSTALLED} $target"
    fi
  done
  if [ -n "$NOT_INSTALLED" ]; then
    echo "WARNING: The following packages are not installed: ${NOT_INSTALLED}"
  fi
  true
fi
