set -u

. $UTIL_SH

for exe in dirloop_sse dmft fulldiag loop pconfig; do
  if [ ! -e ${PREFIX}/bin/${exe} ]; then
    echo "Error: ${PREFIX}/bin/${exe} does not exist"
    exit 127
  fi
done

cp -rp ${PREFIX}/tutorials/ed-01-sparsediag .
cd ed-01-sparsediag
check parameter2xml parm1a
check sparsediag parm1a.in.xml
cd ..

cp -rp ${PREFIX}/tutorials/mc-02-susceptibilities .
cd mc-02-susceptibilities
check parameter2xml parm2c
check loop parm2c.in.xml
cd ..
