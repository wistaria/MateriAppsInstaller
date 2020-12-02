Installation-related file
------------------------------------------

This section describes the format and rules for each file required for the installation of the software.

default.sh
============

A script for specifying the software version.

Variables sandwiched between two underscores are for use in other scripts.

- ``<NAME>_VERSION``
  
  - Version number of software

- ``<NAME>_MA_REVISION``

  - An identifier to distinguish between revised scripts of the MAInstaller for the same version.

- ``__NAME__``

  - Software names used for directory names.
  - In MAInstaller, the name is written in lower case.

- ``__VERSION__``

  - ``<NAME>_VERSION`` is specified.

- ``__MA_REVISION__``

  - ``<NAME>_MA_REVISION`` is specified.

Example ::

  TENES_VERSION="1.1.2"
  TENES_MA_REVISION="0"

  __NAME__=tenes
  __VERSION__=${TENES_VERSION}
  __MA_REVISION__=${TENES_MA_REVISION}


download.sh
===========

A script to get the source code from the internet.

- The source code will be downloaded to ``$SOURCE_DIR`` .

  - Rename the saved file according to the format to reduce the difference between software as much as possible.

  - In particular, be sure to give the version number so that it can be distinguished.

- Skip if already downloaded

  - In the environment where external access is not possible, files can be placed manually.

Example ::

    SCRIPT_DIR=$(cd "$(dirname $0)"; pwd)
    . $SCRIPT_DIR/../../scripts/util.sh
    . $SCRIPT_DIR/version.sh
    set_prefix

    if [ -f $SOURCE_DIR/${__NAME__}-${__VERSION__}.tar.gz ]; then :; else
      check wget https://github.com/issp-center-dev/TeNeS/archive/v${__VERSION__}.tar.gz -O $SOURCE_DIR/${__NAME__}-${__VERSION__}.tar.gz
    fi


setup.sh
===========

A script for extracting archive files.

- Run ``download.sh`` and get the archive file.

  - ``download.sh`` will check if it has already been downloaded.

- Extract archive files in ``$SOURCE_DIR`` to ``$BUILD_DIR`` .

  - Rename the extracted directory according to the format.

- Apply patch files, if any, in the ``patch`` directory.

Example ::

  SCRIPT_DIR=$(cd "$(dirname $0)"; pwd)
  . $SCRIPT_DIR/../../scripts/util.sh
  . $SCRIPT_DIR/version.sh
  set_prefix

  sh ${SCRIPT_DIR}/download.sh

  cd $BUILD_DIR
  if [ -d ${__NAME__}-${__VERSION__} ]; then :; else
    check mkdir -p ${__NAME__}-$__VERSION__
    tarfile=$SOURCE_DIR/${__NAME__}-${__VERSION__}.tar.gz
    sc=`calc_strip_components $tarfile README.md`
    check tar zxf $tarfile -C ${__NAME__}-${__VERSION__} --strip-components=$sc
    cd ${__NAME__}-$__VERSION__
    if [ -f $SCRIPT_DIR/patch/${__NAME__}-${__VERSION__}.patch ]; then
      patch -p1 < $SCRIPT_DIR/patch/${__NAME__}-${__VERSION__}.patch
    fi
  fi


link.sh
===========

A script that creates a symbolic link for a configuration file.

- The destination of the symbolic link is different for the application and the tool.

  - For software packages, ``$MA_ROOT/$__NAME__/${__NAME__}vars.sh``

  - Fot tools, ``$MA_ROOT/env.d/${__NAME__}vars.sh``

Example ::

  SCRIPT_DIR=$(cd "$(dirname $0)"; pwd)
  . $SCRIPT_DIR/../../scripts/util.sh
  . $SCRIPT_DIR/version.sh
  set_prefix

  . $MA_ROOT/env.sh

  VARS_SH=$MA_ROOT/${__NAME__}/${__NAME__}vars-$__VERSION__-$__MA_REVISION__.sh
  rm -f $MA_ROOT/${__NAME__}/${__NAME__}vars.sh
  ln -s $VARS_SH $MA_ROOT/${__NAME__}/${__NAME__}vars.sh


README.md
===========

The following information on the software is described:

- Software name
- Summary
- License
- Official page
- MateriApps URL

The information is taken from 
`A portal site of Materials Science Simulation MateriApps <https://ma.issp.u-tokyo.ac.jp>`_.

Example ::

  HΦ
  ==

  SUMMARY
  -------

  An exact diagonalization package for a wide range of quantum lattice
  models (e.g. multi-orbital Hubbard model, Heisenberg model, Kondo
  lattice model). HΦ also supports the massively parallel computations.
  The Lanczos algorithm for obtaining the ground state and thermal pure
  quantum state method for finite-temperature calculations are
  implemented. In addition, dynamical Green’s functions can be calculated
  using , Kω which is a library of the shifted Krylov subspace method. It
  is possible to perform simulations for real-time evolution from ver. 3.0.

  LICENSE
  -------

  GNU GPL version 3

  OFFICIAL PAGE
  -------------

  http://www.pasums.issp.u-tokyo.ac.jp/hphi/en/

  MateriApps URL
  --------------

  https://ma.issp.u-tokyo.ac.jp/en/app/367



Management file (``scripts/`` )
---------------------------------

check_prefix.sh
===================

A script that defines the functions used in the script.


fix_dylib.sh
===================

T.B.A.


list_maversion.sh
===================

T.B.A.

util.sh
=================

T.B.A.
