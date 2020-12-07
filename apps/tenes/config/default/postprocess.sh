set -u

if [ -f ${ISSP_UCOUNT} ]; then

  cd $PREFIX/bin
  for file in tenes; do
    mv ${file} ${file}_nocount
    cat << EOF > ${file}
#!/bin/sh
${ISSP_UCOUNT} tenes
${PREFIX}/bin/${file}_nocount \$@
EOF
    chmod +x ${file}
  done
fi
