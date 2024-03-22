if [ -x $ISSP_UCOUNT ]; then

if [ -d ${PREFIX}/local ]; then
  PREFIX=${PREFIX}/local
fi

cd ${PREFIX}/bin
  for file in hwave; do
    mv ${file} ${file}_nocount
    cat << EOF > ${file}
#!/bin/sh
${ISSP_UCOUNT} hwave
${PREFIX}/bin/${file}_nocount \$@
EOF
    chmod +x ${file}
  done
fi
