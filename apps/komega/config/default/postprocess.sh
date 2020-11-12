set -u

if [ -f ${ISSP_UCOUNT} ]; then

  cd $PREFIX/bin
  for file in ShiftK.out; do
    mv ${file} ${file}_nocount
    cat << EOF > ${file}
#!/bin/sh
${ISSP_UCOUNT} komega
${PREFIX}/bin/${file}_nocount \$@
EOF
    chmod +x ${file}
  done
fi
