Installation to Linux (using gcc)
------------------------------------------------------------

This section describes how to use the MateriApps Installer on Linux OS.
We have checked it on CentOS 7 and Ubuntu 20. (You should be able to install other distributions using the same procedure.)
Tools (gcc, cmake, etc.) preinstalled in Linux OS may be used, but if any trouble occurs, you have to estimate its reason from the error message and have to solve the trouble by your self.
If you are not sure of doing this, we recommend that you install all the tools through MateriApps Installer.

Initial setup
****************************

Perform initial setup.
Enter the root directory of MateriApps Installer and run the following command: ::

$ sh setup/setup.sh

You only need to do this once at the beginning.

Installing gcc
****************************

Install the compiler first. (It is also possible to use the gcc compiler already installed in Linux OS to install subsequent tools, but some applications may not install well with the older gcc compiler. If you are not familiar with troubleshooting, it is recommended that you use the gcc compiler with MateriApps Installer.) To install gcc 10, execute the following commands: ::

$ cd tools/gcc10
$ sh install.sh

Installing gcc10 takes a long time. If you are installing to a remote computer server, it may be helpful to run the last command in the background with the following changes: ::

$ sh install.sh > log &

In this case, the progress of the installation can be seen in the log file generated in the same directory (For example, run "cat log").
If the installation is successful, execute the following command: ::

$ sh link.sh	   

This copies a link to the script that initializes the tool usage to the given location (default: $HOME/materiapps/env.d).
Finally, run the copied configuration file and make it available for subsequent tools and applications. ::

$ source $HOME/materiapps/env.sh

If you have successfully installed gcc 10, you do not need to install gcc 8. Rarely, installation of gcc 10 may fail on older Linux OSs. Install gcc8 only in this case. The installation procedure is the same as gcc10, except that you first enter tools/gcc8 directory.

Installing cmake
****************************

Some applications use cmake to install. Major Linux distributions already include cmake, but older versions of cmake may fail to install some applications. Versions 3.6 and later are fine. To install cmake, run the following command immediately after installing the gcc compiler: ::

$ cd ../cmake
$ sh install.sh
$ sh link.sh
$ source $HOME/materiapps/env.sh

Installing other tools
****************************

Install the remaining tools in the same way. For example, if you want to install git immediately after you install cmake, run the following command: ::

$ cd ../git
$ sh install.sh
$ sh link.sh
$ source $HOME/materiapps/env.sh

To install all the tools, please first install git, libffi, and python3 in this order, and then install the remaining tools in alphabetical order (boost, eigen3, fftw, gsl, hdf5, lapack, libffi, openmpi, openssl, scalapack, tcltk, zlib). (You must install openmpi first before installing scalapack.) The command for installation is identical except that you first enter the directory, which is the name of the tool to be installed.

Installing applications
**************************

After installing the tools, enter the directory of the application you want to install, set the execution environment of the tools, and execute the installation script: ::

$ sh $HOME/materiapps/env.sh
$ sh install.sh

You can check whether it is installed correctly by executing the following command in the directory of each application: ::

$ sh runtest.sh

(You must install quantum ESPRESSO before running runtest.sh for respack. You must also set up an execution environment for quantum ESPRESSO as described in the next section.)

If you pause in the middle of downloading and installing an application, the source files may remain, which may not work when you reinstall. In that case, delete the directory of the target application in the source file ($HOME/materiapps/source by default).

If you get errors during installation, take a closer look at the error messages. Errors often occur because the necessary tools are not installed. Read the required tools from the error message and install the tools.

Once you've successfully completed the test, use the following command to make a link of the preferences file of the application (see also the next section): ::

$ sh link.sh

Setting the execution environment for each application
******************************************************

In order to run the application, you need to set the execution environment. By entering the following commands, you can create an environment in which each application can be executed and the application can be executed immediately. For example, if you have installed HPhi (the installation directory is assumed to be the default, i.e., $HOME/materiapps), you should see a configuration file named hphivars.sh when you execute the following command: ::

$ ls $HOME/materiapps/hphi

Run this configuration file as follows to configure the execution environment. ::

$ source $HOME/materiapps/hphi/hphivars.sh

Then, you are now ready to use the application.
