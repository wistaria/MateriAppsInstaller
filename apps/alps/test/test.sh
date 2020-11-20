set -u

. $UTIL_SH

for exe in dirloop_sse dmft fulldiag loop pconfig; do
  if [ ! -e ${PREFIX}/bin/${exe} ]; then
    echo "Error: ${PREFIX}/bin/${exe} does not exist"
    exit 127
  fi
done

cp -rp ${PREFIX}/tutorials/ed-01-sparsediag .
check (cd ed-01-sparsediag && parameter2xml parm1a && sparsediag parm1a.in.xml)

cp -rp ${PREFIX}/tutorials/mc-02-susceptibilities .
check (cd mc-02-susceptibilities && parameter2xml parm2c && loop parm2c.in.xml)
