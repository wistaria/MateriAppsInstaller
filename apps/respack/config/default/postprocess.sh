if [ -x $ISSP_UCOUNT ]; then

cd ${PREFIX}/bin
  for file in calc_*; do
    if [ ${file} != ${file%.py} ];then
      mv ${file} ${file%.py}_nocount.py
      head -n1 ${file%.py}_nocount.py > ${file}
      cat << EOF >> ${file}
from subprocess import call
import sys
call(['${ISSP_UCOUNT}', 'respack'])
cmds = ['${PREFIX}/bin/${file%.py}_nocount.py']
cmds.extend(sys.argv[1:])
call(cmds)
EOF
      chmod +x ${file}
    else
      mv ${file} ${file}_nocount
      cat << EOF > ${file}
#!/bin/sh
${ISSP_UCOUNT} respack
${PREFIX}/bin/${file%.py}_nocount \$@
EOF
      chmod +x ${file}
    fi
  done
fi
