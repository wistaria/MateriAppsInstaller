cat << EOF > $PREFIX/env.sh
export MA_ROOT=$PREFIX
export PATH=$PREFIX/bin:\$PATH
export LD_LIBRARY_PATH=$PREFIX/lib:\$LD_LIBRARY_PATH
unset i
for i in $PREFIX/env.d/*.sh ; do
  if [ -r "\$i" ]; then
    if [ "\${-#*i}" != "\$-" ]; then
      . "\$i"
    else
      . "\$i" >/dev/null 2>&1
    fi
  fi
done
unset i
EOF
