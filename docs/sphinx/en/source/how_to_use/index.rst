********************************
Usage
********************************

Download
============

- You can download MateriApps Installer by the following steps.
  
  - Download the release version

    Go to the `MateriApps Installer release page <https://github.com/wistaria/MateriAppsInstaller/tags>`_ to download the zip file and then extract it.
    The zip file you download from the release page includes a pdf version of this manual.

  - Download with git
    
    You can download the MateriApps Installer by typing the following command.

     .. code-block:: bash

	git clone https://github.com/wistaria/MateriAppsInstaller.git

Directory Structure
===================

- The structure of the directory after extraction is as follows.

  .. code-block:: bash

		  |─ setup
		  |─ apps
		  |─ docs
		  |─ tools
		  |─ check
		  |   |- k.sh
		  |   |- macos.sh
		  |   |- sekirei.sh
		  |   |─ zetta-gcc.sh
		  |   |- zetta-intel.sh
		  |─ check_prefix.sh
		  |─ fix_dylib.sh
		  |─ list_maversion.sh
		  |─ macosx
		  |   |─ install.sh
		  |   |─ ports.sh
		  |- README.md
		  |- util.sh


- The directory structure in setup, tools, and apps is given as follows.

  .. code-block:: bash

	  -- software_name
		|- README.md
		|- download.sh
		|- link.sh
		|- setup.sh
		|- version.sh
		|- install.sh
		|- patch 
	  	|- config 
 

  Each file and directory is described below (see File Format for details).    
  Files marked with * indicate files that always exist in the directory.
  
  - README.md (*)

    - It includes a brief introduction of the software and the URLs of the official website.

  - download.sh (*)

    - Download the source code archive

  - link.sh (*)

    - Create symbolic links to installed directories and configuration files

  - setup.sh (*)

    - Extract the prepared source code archive and apply the patch (if it exists)

  - version.sh (*)

    - Specify the version to download

  - install.sh (*)

    - Building and installing the program

  - patch

    - The directory where the patches are stored

  - config

    - Additional settings for installation other than the default settings, such as when using the Intel Compiler

- In addition to the above, the following file directories are also available.

  - check_prefix.sh

    - Script to display variables that are commonly used in each script, such as the top installation directory
    
  - list_maversion.sh

    - A script that summarizes the information of ``version.sh`` in each directory

  - check directory

    - A script to run multiple installation scripts in sequence on various hosts

  - docs directory

    - A directory containing the manual and its source code

  - macosx directory

    - A directory containing scripts to install the necessary tools using Macports

  - scripts directory

    - A directory containing a set of administrative scripts

  - setup directory

    - A directory containing scripts to prepare for software installation (see Setup below for details)

Setup
============
- Run ``setup/setup.sh`` before installing the software

  .. code-block:: bash

     sh setup/setup.sh

  This script creates installation scripts, installation scripts and working scripts


- Configuring the installation location for applications extracted by the MateriApps Installer

   - You can change the installation location by setting the following options in ``$HOME/.mainstaller``.

     The installation location can be set in the ``$HOME/.mainstaller`` file as follows (you have to create it yourself)
     
      # Do not put spaces before or after = as it will be treated as a shell script

      MA_ROOT=$HOME/materiapps  # Software installation directory
      BUILD_DIR=$HOME/build     # Installation directory
      SOURCE_DIR=$HOME/source   # File download directory


     
      .. csv-table:: Explanation of options
	 :header: "option", "default", "description"
	 :widths: 15, 15, 30

        ``MA_ROOT`` , ``$HOME/materiapps``,  Software installation directory
        ``BUILD_DIR`` , ``$HOME/build`` , Installation directory
        ``SOURCE_DIR`` , ``$HOME/source`` , Source code archive file download directory

    - If this file does not exist, the software will be installed under ``$ HOME materiapps``
    - (*) Note that the actual installation location uses the contents of the ``.mainstaller`` file at the time of the installation work described below.

Install
============

- Move to each software directory and run `` install.sh``. ::

     sh install.sh

  
    - When this script is executed, the build and installation will be performed automatically after downloading (``download.sh``) and extracting (``setup.sh``) the source code.
    - Depending on the software, settings for the compiler and libraries may have been defined, and they are stored as subdirectories under the ``config`` directory.

    - If you want to specify the compiler, you can add the compiler name after ``install.sh``. The following is an example of compiling with ``intel``.
      
      .. code-block:: bash

         sh install.sh ``intel``

        - If you specify a settings directory that does not exist, a list of available settings is displayed.::

	  $ sh install.sh help
	  Error: unknown mode: help
	  Available list:
	  default
	  intel

      - ``default``

        - Basic settings used when the argument is omitted

      - ``intel``

        - Settings for using Intel compiler, Intel MKL, Intel MPI

    -  The compiler etc. can be directly specified using shell variables

      - ex.) A case of using the Intel compiler as the C compiler while using the default settings ::

        CC=`which icc` sh install.sh

      - Compiler options can be added by setting ``MA_EXTRA_FLAGS`` ::

        MA_EXTRA_FLAGS="-march=core-avx2" sh install.sh intel

      - The path of the ``cmake`` command can be specified using ``CMAKE``

      - ``ISSP_UCOUNT`` is the path of the utilization rate measurement script in Supercomputer on Institute for Solid State Physics, and most users do not have to worry about it

      - For other variables available, see the beginning description of ``install.sh``.

- Run a simple test with ``sh runtest.sh``

  - Check the existence of the installation directory
  - Check the validity of the configuration file
  - Check if the software actually works

- The software is installed in the ``$ MA_ROOT/NAME/NAME-VERSION-MA_REVISION`` directory

  - ``NAME`` and ``VERSION`` are replaced with the software name and version respectively

    - ``MA_REVISION`` is an identifier that distinguishes when the MateriApps Installer is revised for the same version of software.
    - ex.) ``hphi/hphi-3.4.0-1``

  - Along with the software, the configuration file ``NAMEvars-VERSION-MA_REVISION.sh`` that sets environment variables etc. is installed in ``$MA_ROOT/NAME/``

    - ex.) ``hphivars-3.4.0-1.sh`` 

    - Running ``sh link.sh`` creates a symbolic link ``NAMEvars.sh`` for ``NAMEvars-VERSION.sh``

      - For apps, it is created under ``NAME``
      - For tools, it is created under ``$MA_ROOT/env.d`` and loaded in ``$MA_ROOT/env.sh``.
	 
How to use the tools and apps
=============================

- Tools (cmake, hdf5, python, etc.)
   
   - Run the following command (or write the same command in a shell initialization script)

     .. code-block:: bash

	source $PREFIX_TOOL/env.sh

- Applications (ALPS, OpenMX, MODYLAS, etc.)

   - Set environment variables (e.g. ``PATH``) for each application using scripts.
    
     For example, in the case of ALPS:

     .. code-block:: bash

	source $PREFIX_ALPS/alps/alpsvar.sh

   - If you want to fix the version, use the configuration file of that version. ::
      
      source $MA_ROOT/alps/alpsvar-20201106-r7860-1.sh
