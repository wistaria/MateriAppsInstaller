set -u
set -o pipefail

for exe in dirloop_sse dmft fulldiag loop pconfig; do
  if [ ! -e ${PREFIX}/bin/${exe} ]; then
    echo "Error: ${PREFIX}/bin/${exe} does not exist"
    exit 127
  fi
done

cp -rp ${PREFIX}/tutorials/ed-01-sparsediag .
(cd ed-01-sparsediag && parameter2xml parm1a && sparsediag parm1a.in.xml) 2>&1 | tee -a log || exit 127

cp -rp ${PREFIX}/tutorials/mc-02-susceptibilities .
(cd mc-02-susceptibilities && parameter2xml parm2c && loop parm2c.in.xml) 2>&1 | tee -a log || exit 127
