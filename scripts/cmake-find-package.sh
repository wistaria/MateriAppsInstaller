#!/bin/sh

DEBUG=

if [ -n "$1" ]; then
  if [ "$1" = "-d" ]; then
    DEBUG=yes
    PACKAGE="$2"
    VERSION_VAR=${3:-${PACKAGE}_VERSION}
  else
    PACKAGE="$1"
    VERSION_VAR=${2:-${PACKAGE}_VERSION}
  fi
fi
if [ -z ${PACKAGE} ]; then
  echo "Usage: $0 [-d] PACKAGE [VERSION_VAR]"
  exit 127
fi

WORK_DIR="${TMPDIR}find-package.$$"
mkdir -p ${WORK_DIR}

cat << EOF > ${WORK_DIR}/CMakeLists.txt
cmake_minimum_required(VERSION 3.1 FATAL_ERROR)
project(find)
find_package(${PACKAGE})
message(STATUS "find-package-found: \${${PACKAGE}_FOUND}")
message(STATUS "find-package-version: \${${VERSION_VAR}}")
EOF

(cd ${WORK_DIR} && cmake -DCMAKE_FIND_DEBUG_MODE=1 . > output.txt 2>&1)
if [ -z "$DEBUG" ]; then
  FOUND=$(grep 'find-package-found:' ${WORK_DIR}/output.txt | awk '{print $3}')
  VERSION=$(grep 'find-package-version:' ${WORK_DIR}/output.txt | awk '{print $3}')
  if [ -z "$VERSION" ]; then
    test "$FOUND" = "TRUE" && echo "yes" || echo ""
  else
    echo $VERSION
  fi
else
  cat ${WORK_DIR}/output.txt
fi

rm -rf ${WORK_DIR}
