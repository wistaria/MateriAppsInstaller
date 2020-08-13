cd ${PREFIX}/bin
for file in *; do
  if [ ${file} != ${file%.py} ];then
    mv ${file} ${file%.py}_nocount.py
    head -n1 ${file%.py}_nocount.py > ${file}
    cat << EOF >> ${file}
from subprocess import call
import sys
call(['/home/issp/materiapps/tool/bin/issp-ucount', 'respack'])
cmds = ['${PREFIX}/bin/${file%.py}_nocount.py']
cmds.extend(sys.argv[1:])
call(cmds)
EOF
    chmod +x ${file}
  else
    mv ${file} ${file}_nocount
    cat << EOF > ${file}
#!/bin/sh
/home/issp/materiapps/tool/bin/issp-ucount respack
${PREFIX}/bin/${file%.py}_nocount \$@
EOF
    chmod +x ${file}
  fi
done
