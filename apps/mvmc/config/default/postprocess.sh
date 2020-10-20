set -u

if [ -x $ISSP_UCOUNT ] ; then
  cd $PREFIX/bin
  for file in vmc.out; do
    mv ${file} ${file}_nocount
    cat << EOF > ${file}
#!/bin/sh
$ISSP_UCOUNT mvmc
${PREFIX}/bin/${file}_nocount \$@
EOF
  chmod +x ${file}
  done
fi
