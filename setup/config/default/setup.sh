cat << EOF > $MA_ROOT/env.sh
export MA_ROOT=$MA_ROOT
export PATH=\$MA_ROOT/bin:\$PATH
export LD_LIBRARY_PATH=\$MA_ROOT/lib:\$LD_LIBRARY_PATH
unset i
for i in \$(find \$MA_ROOT/env.d -name '*.sh'); do
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
