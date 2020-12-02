.. MA-Installer documentation master file, created by
   sphinx-quickstart on Sun May 10 14:29:22 2020.
   You can adapt this file completely to your liking, but it should at least
   contain the root `toctree` directive.

Overview of MateriApps Installer
------------------------------------------
MateriApps Installer is a collection of shell scripts to assist in the installation of computational material science applications for various computing environments. The MateriApps Installer includes shell scripts to be installed on Linux PCs, cluster workstations, and major supercomputer systems. MateriApps Installer is also used for pre-installation for domestic joint-use supercomputers (a list of installed software can be found in Chapter of Application List).


Background of the Development
------------------------------------------
Nowadays, computer numerical computation is indispensable to promote theoretical research in materials science. For advancement of computational materials science, the development of algorithms to solve equations of materials science efficiently plays an important role, and many excellent applications with efficient algorithms, excellent parallel performance, and state-of-the-art functions have been created. In 2013, we launched a portal site for materials science simulations, `MateriApps <http://ma.cms-initiative.jp>`_, in order to disseminate information about the developed software to experimentalists and corporate researchers. I have been disseminating information about the application.

One of the obstacles for users to start using published applications in materials science is the installation of software. `MateriApps LIVE! <https://cmsi.github.io/MateriAppsLive/>`_ is an environment that allows users to easily try out computational materials science applications on their laptops and other devices. MateriApps LIVE! is a Virtual Hard Disk Image (OVA) of VirtualBox that includes applications, OS (Debian GNU/Linux), editors, visualization tools, and other environments needed to get started with the tutorial. By using MateriApps LIVE!, it is possible to easily set up a computing environment for participants in classes and software training sessions.

However, the calculation environment provided by MateriApps LIVE! is not sufficient for practical applications. To enable users to easily install applications of computational materials science in a wide range of computing environments, from major domestic joint-use supercomputers to clustered computers in laboratories and personal computers, the development of MateriApps Installer has been started.

Goal of MateriApps Installer
------------------------------------------
The goals of MateriApps Installer are as follows

- To install common applications (cf. `MateriApps <http://ma.cms-initiative.jp>`_) on all major domestic and foreign supercomputers.
- Similarly, we will prepare scripts for installation on CentOS (RedHat), Debian (Ubuntu) and Mac OS X environments.



List of tools and apps
------------------------------------------

The following tools and apps are in place (12/2/2020):

1. Tools

  boost, cmake, eigen3, fftw, gcc10, gcc7,
  git, gsl, hdf5, lapack, libffi, openblas,
  openmpi, openssl, python2, python3, scalapack, tcltk, zlib


2. Apps

  ALPS, DSQSS, QUANTUM ESPRESSO, HΦ, Kω, mVMC, OpenMX, RESPACK, TeNeS


3. Apps to be added in the future

  abICS, DCore, ALPS-Core, TRIQS



Design Policies
------------------------------------------
The design policy of MateriApps Installer is as follows:

1. Do not depend on special tools (shell, make, tar, etc. are sufficient).

2. Supercomputers are different from each other, so do not aim to make a universal installer, but make a separate script for exceptions.

3. As for the tools, if the package is already available for Linux (RPM Package, Debian Package) or Mac OS X (MacPorts), use it.

4. The version of the application should be the same as MateriApps LIVE! Necessary patches should also be the same as in Debian Package for MateriApps LIVE!

5. Use a separate folder for each tool/application. Prepare a separate folder for each tool/application.

    - For example, in the case of cmake

     .. code-block:: bash

	$PREFIX_TOOL/cmake/cmake-3.2.1-1


6. Prepare an environment variable setting script for each tool/application/version.

    - Example for cmake

     .. code-block:: bash

   	$PREFIX_TOOL/cmake/cmakevars-3.2.1-1.sh.

7. For the environment variables of the tools, link to ``PREFIX_TOOL/env.d`` so that we can keep the old version for collective setting in ``PREFIX_TOOL/env.sh``.
   
8. Separate installation and relinking (it does not affect anything else until the relinking is done). 

9. Install to a different location for testing.

Main developers
------------------------------------------
MateriApps Installer is developed by the following members.

- ver. xxx
   - Shinji Todo (Graduate School of Science, The University of Tokyo)
   - Yuichi Motoyama (Institute for Solid State Physics, The University of Tokyo)
   - Kazuyoshi YOSHIMI (Institute for Solid State Physics, The University of Tokyo)
   - Takeo Kato (Institute for Solid State Physics, The University of Tokyo)

   
Version history
------------------------------------------

- 2020/xx/yy ver. 1.0 was released.

License
--------------
The program package and source code set of this software is distributed under the GNU General Public License version 3 (GPL v3). However, the patch files for each software are distributed under the license of the software.

Copyright
------------------

*(c) 2020- The University of Tokyo. All rights reserved.*

This software has been developed under the Project for advancement of software usability in material science by Institute for Solid State Physics, The University of Tokyo, and the copyright of this software belongs to the University of Tokyo.
