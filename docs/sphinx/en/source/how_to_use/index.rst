********************************
Usage
********************************

Download
============

- You can download MateriAppsInstaller by following the steps below.
  
  - Download the release version

    Go to the MateriAppsInstaller release page (URL to be added later) to download the zip file and then extract it.
    The zip file you download from the release page includes a pdf version of this manual.

  - Download with git
    
    You can download the MateriAppsInstaller by typing the following command.

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

  - README.md (essential)

    - It includes a brief introduction to the software and the URL of the official website.

  - download.sh (essential)

    - Download the source code archive

  - link.sh (essential)

    - Create symbolic links to installed directories and configuration files

  - setup.sh (essential)

    - Extract the prepared source code archive and apply the patch (if it exists)

  - version.sh (essential)

    - Specify the version to download

  - install.sh (essential)

    - Building and installing the program

  - patch (optional)

    - The directory where the patches are stored

  - config (optional)

    - Additional settings for installation other than the default settings, such as when using an Intel compiler

- In addition to the above, the following file directories are also available.

  - list_maversion.sh

    - A script that summarizes the version.sh information in each directory

  - util.sh

    - Defines utility functions to be used in the script, such as installation directory settings

  - check_prefix.sh

    - Script to display variables that are commonly used in each script, such as the top installation directory

  - check directory

    - A script to run multiple installation scripts in sequence on various hosts

  - fix_dylib.sh

    - Script to modify RPATH information on macOS

  - macosx directory

    - A script to install the necessary tools using Macports

Setup
============

- Configuring the installation location for applications deployed by the MateriApps Installer

   - By default, the software is installed under ``$HOME/materiapps``.
   - You can change the installation location by setting the following options in ``$HOME/.mainstaller``.

      .. csv-table:: Title of table
	 :header: "option", "default", "description"
	 :widths: 15, 15, 30

         ``PREFIX`` , ``$HOME/materiapps``,  Tool and app installation location (if you want to install them both in the same place)
         ``PREFIX_TOOL`` , ``$HOME/materiapps`` ,Where to install the tool
         ``PREFIX_APPS`` , ``$HOME/materiapps`` ,Where to install the application software
         ``BUILD_DIR`` , ``$HOME/build`` ,Where to build
         ``SOURCE_DIR`` , ``$HOME/source`` ,Source tarball directory

-  The installation directory (the directory specified in ``PREFIX``, ``PREFIX_TOOL`` and ``PREFIX_APPS`` above) is newly created.

Install
============

- Run "install.sh" for each application.

    - In each application's config sub folder, there is a subdirectory with the compiler name corresponding to the installation (gcc, intel, etc.).
    - If you want to specify the compiler, you can add the compiler name after install.sh. The following is an example of compiling with gcc.
      
      .. code-block:: bash

         sh install.sh gcc


How to use the tools and apps
=============================

- Tools (cmake, hdf5, python, etc.)
   
   - Run the following command (or write the same in a shell initialization script)

     .. code-block:: bash

	source $PREFIX_TOOL/env.sh

- Applications (alps, openmx, modylas, etc.)

   - Set environment variables (e.g. ``PATH``) for each app using scripts.
    
      For example, in the case of alps:

      .. code-block:: bash

	 source $PREFIX_ALPS/alps/alpsvar.sh

-  How to test the installation

   -  T.B.A.

-  Sample batch script

   -  T.B.A.
