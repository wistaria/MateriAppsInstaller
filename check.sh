#!/bin/sh

check() {
  "$@"
  result=$?
  if [ $result -ne 0 ]; then
    echo "Failed: $@" >&2
    exit $result
  fi
  return 0
}
