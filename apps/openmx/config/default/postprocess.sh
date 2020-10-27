cp -rp DFT_DATA* work $PREFIX

set -u

if [ -x $ISSP_UCOUNT ]; then
  cd $PREFIX/bin
  for file in openmx; do
    mv ${file} ${file}_nocount
    cat << EOF > ${file}
#!/bin/sh
${ISSP_UCOUNT} openmx
${PREFIX}/bin/${file}_nocount \$@
EOF
    chmod +x ${file}
  done
fi
