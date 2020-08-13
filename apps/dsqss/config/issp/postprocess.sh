cd $PREFIX/bin
for file in dla pmwa_B pmwa_H; do
  mv ${file} ${file}_nocount
  cat << EOF > ${file}
#!/bin/sh
/home/issp/materiapps/tool/bin/issp-ucount dsqss
${PREFIX}/bin/${file}_nocount \$@
EOF
  chmod +x ${file}
done
