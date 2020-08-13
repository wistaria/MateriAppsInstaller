cd $PREFIX/bin
for file in tenes; do
  mv ${file} ${file}_nocount
  cat << EOF > ${file}
#!/bin/sh
/home/issp/materiapps/tool/bin/issp-ucount tenes
${PREFIX}/bin/${file}_nocount \$@
EOF
  chmod +x ${file}
done
