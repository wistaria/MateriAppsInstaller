Installation to MacOS 10.15 (Catalina)
------------------------------------------------------------

This section describes how to use the MateriApps Installer on MacOS 10.15 (Catalina).

Installing Tools
****************************

It is more convenient to install the tools in the tools directory using the MacOS package management software (Homebrew, find, macports, etc.). Here, we show examples using Homebrew. In this case, we use the default setting for directory of the application. The install directory is $HOME/materiapps and the build directory is $HOME/build.

Follow the instructions at https://brew.sh/ to install Homebrew.

   .. raw:: html

      <div class="hcb_wrap">

   .. code:: prism

       $ /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"

   .. raw:: html

      </div>

Then install the tools via Homebrew. If the installation has already been done by another method, you do not need to install it in Homebrew. You can install all of the following tools first, or you can install them when required by the app installation. (python2 is pre-installed in MacOS.)

   .. raw:: html

      <div class="hcb_wrap">

   .. code:: prism

	$ brew install gcc
	$ brew install boost
	$ brew install cmake
	$ brew install eigen
	$ brew install fftw
	$ brew install git
	$ brew install gsl
	$ brew install hdf5
	$ brew install lapack
	$ brew install libffi
	$ brew install openblas
	$ brew install openmpi
	$ brew install openssl
	$ brew install python@3
	$ brew install scalapack
	$ brew install tcl-tk
	$ brew install zlib

   .. raw:: html

      </div>

Some applications also require you to install the following tools:.

   .. raw:: html

      <div class="hcb_wrap">

   .. code:: prism

	$ brew install svn
	$ brew install boost-python
	$ brew install boost-python3
	$ brew install boost-mpi
	$ brew install wget

   .. raw:: html

      </div>

In addition, some applications require you to install the python library. Install it with the following command:

   .. raw:: html

      <div class="hcb_wrap">

   .. code:: prism

	$ pip3 install numpy --user
	$ pip3 install scipy --user
	$ pip3 install toml --user

   .. raw:: html

      </div>

Installing Applications
**************************

Perform initial setup (Create required directories, etc.).
Go to the MateriAppsInstaller directory, and run the following command.

   .. raw:: html

      <div class="hcb_wrap">

   .. code:: prism

	$ sh setup/setup.sh

   .. raw:: html

      </div>

Next, enter the directory of the application you want to install and run the following command to install it.

   .. raw:: html

      <div class="hcb_wrap">

   .. code:: prism

	$ CC=gcc-10 FC=gfortran-10 CPP=cpp-10 sh ./install.sh

   .. raw:: html

      </div>

You can check whether it is installed correctly by executing the following command in the directory of each application.

   .. raw:: html

      <div class="hcb_wrap">

   .. code:: prism

	$ sh ./runtest.sh

   .. raw:: html

      </div>

(You must install quantum ESPRESSO before running runtest.sh for respack. You must also set up an execution environment for quantum ESPRESSO as described in the next section.)

If you pause in the middle of downloading, the source files may remain, which may not work when you reinstall. In this case, delete all the target application directories in the source file (see the directory $HOME/materiapps/source in the default setting).

If you get errors during installation, take a closer look at the error messages. Errors often occur because the necessary tools are not installed. Read the required tools from the error message and install the tools.

Setting the execution environment
**************************

In order to run the application, you need to set the execution environment. By entering the following commands, you can create an environment in which each application can be executed. For example, if you want to run ::math:`{\rm H}\Phi` that is already installed, then output the filenames for the setting file as follows.

   .. raw:: html

      <div class="hcb_wrap">

   .. code:: prism

	$ ls $HOME/materiapps/hphi

   .. raw:: html

      </div>

You will find the file named "hphivars-(version number).sh". Execute this setting file as follows.

   .. raw:: html

      <div class="hcb_wrap">

   .. code:: prism

	$ source $HOME/materiapps/hphi/hphivars-(version number).sh

   .. raw:: html

      </div>
	  
Then, you are now ready to run the applications.
