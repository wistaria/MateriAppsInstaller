#!/bin/sh

PACKAGE="$1"
VERSION_VAR=${2:-${PACKAGE}_VERSION}

if [ -z ${PACKAGE} ]; then
  echo "Usage: $0 PACKAGE"
  exit 127
fi

WORK_DIR="${TMPDIR}find-package.$$"
mkdir -p ${WORK_DIR}

cat << EOF > ${WORK_DIR}/CMakeLists.txt
cmake_minimum_required(VERSION 3.1 FATAL_ERROR)
project(find)
find_package(${PACKAGE})
message(STATUS "find-package-result: \${${VERSION_VAR}}")
EOF

(cd ${WORK_DIR} && cmake -DCMAKE_FIND_DEBUG_MODE=1 .)

rm -rf ${WORK_DIR}
