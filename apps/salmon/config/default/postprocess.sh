set -u

if [ -x $ISSP_UCOUNT ]; then
  cd $PREFIX/bin
  for file in salmon; do
    mv ${file} ${file}_nocount
    cat << EOF > ${file}
#!/bin/sh
${ISSP_UCOUNT} salmon
${PREFIX}/bin/${file}_nocount \$@
EOF
    chmod +x ${file}
  done
fi
