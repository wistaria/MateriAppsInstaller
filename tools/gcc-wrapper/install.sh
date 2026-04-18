#!/bin/sh

export SCRIPT_DIR=$(cd "$(dirname $0)"; pwd)
export UTIL_SH=${SCRIPT_DIR}/../../scripts/util.sh
. ${UTIL_SH}
. ${SCRIPT_DIR}/version.sh
set_prefix

. ${MA_ROOT}/env.sh
export PREFIX="${MA_ROOT}/${__NAME__}/${__NAME__}-${__VERSION__}-${__MA_REVISION__}"
if [ -d ${PREFIX} ]; then
  echo "Error: ${PREFIX} exists"
  exit 127
fi

if [ -z ${HOMEBREW_PREFIX} ]; then
  if [ -e "/opt/homebrew/bin/brew" ]; then
    eval $(/opt/homebrew/bin/brew shellenv)
  elif [ -e "/usr/local/bin/brew" ]; then
    eval $(/usr/local/bin/brew shellenv)
  fi
fi

FOUND=0
GCC_VERSION=""
if [ -n ${HOMEBREW_PREFIX} ]; then
  VERSIONS="20 19 18 17 16 15 14 13 12 11 10 9 8"
  for v in ${VERSIONS}; do
    if [ -f ${HOMEBREW_PREFIX}/bin/gcc-${v} ]; then
      FOUND=1
      GCC_VERSION=${v}
      mkdir -p ${PREFIX}/bin
      PROGS="c++ cpp g++ gcc gcc-ar gcc-nm gcc-ranlib gcov gcov-dump gcov-tool gdc gfortran lto-dump"
      for p in ${PROGS}; do
	if [ -f ${HOMEBREW_PREFIX}/bin/${p}-${v} ]; then
	  ln -s ${HOMEBREW_PREFIX}/bin/${p}-${v} ${PREFIX}/bin/${p}
	fi
      done
      break
    fi
  done
fi

if [ ${FOUND} = 0 ]; then
  echo "Error: Homebrew GCC compiler not found"
  exit 127
fi

ROOTNAME=$(toupper ${__NAME__} | sed 's/-/_/g')_ROOT
cat << EOF > ${BUILD_DIR}/${__NAME__}vars.sh
# ${__NAME__} $(basename $0 .sh) ${__VERSION__} ${__MA_REVISION__} $(date +%Y%m%d-%H%M%S)
export ${ROOTNAME}=$PREFIX
export PATH=\${${ROOTNAME}}/bin:\$PATH
export OMPI_CC=gcc-${GCC_VERSION}
export OMPI_CXX=g++-${GCC_VERSION}
export OMPI_FC=gfortran-${GCC_VERSION}

# workaround for bug in Xcode 26.4.1
SDK_PATH="/Library/Developer/CommandLineTools/SDKs/MacOSX15.sdk/"
if pkgutil --pkg-info com.apple.pkg.Xcode 2>/dev/null | grep -q '26\.4\.1\.0\.1\.1775746635' \
   && [ -d "\$SDK_PATH" ]; then
    export SDKROOT="\$SDK_PATH"
fi
EOF
VARS_SH=${MA_ROOT}/${__NAME__}/${__NAME__}vars-${__VERSION__}-${__MA_REVISION__}.sh
rm -f ${VARS_SH}
cp -f ${BUILD_DIR}/${__NAME__}vars.sh ${VARS_SH}
