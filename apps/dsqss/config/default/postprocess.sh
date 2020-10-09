set -u 

if [ -x $ISSP_UCOUNT ]; then
  cd $PREFIX/bin
  for file in dla pmwa_B pmwa_H; do
    mv ${file} ${file}_nocount
    cat << EOF > ${file}
#!/bin/sh
$ISSP_UCOUNT dsqss
${PREFIX}/bin/${file}_nocount \$@
EOF
  chmod +x ${file}
  done
fi
