cd $PREFIX/bin
for file in HPhi; do
  mv ${file} ${file}_nocount
  cat << EOF > ${file}
#!/bin/sh
/home/issp/materiapps/tool/bin/issp-ucount hphi
${PREFIX}/bin/${file}_nocount \$@
EOF
  chmod +x ${file}
done
