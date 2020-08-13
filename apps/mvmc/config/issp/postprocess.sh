cd $PREFIX/bin
for file in vmc.out; do
  mv ${file} ${file}_nocount
  cat << EOF > ${file}
#!/bin/sh
/home/issp/materiapps/tool/bin/issp-ucount mvmc
${PREFIX}/bin/${file}_nocount \$@
EOF
  chmod +x ${file}
done
