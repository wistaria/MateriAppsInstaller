# MateriApps Installer

Install script collection for MateriApps Software

# Document

- [English](https://wistaria.github.io/MateriAppsInstaller/manual/master/en/index.html)
- [日本語](https://wistaria.github.io/MateriAppsInstaller/manual/master/ja/index.html)

# Quick Usage

1. Specify install direcoty
    - `echo MA_ROOT=$HOME/materiapps > ~/.mainstaller`
2. Setup
    - `(cd setup; sh setup.sh)`
3. Install application(s) you desire (e.g., HPhi)
    - `cd apps/hphi`
    - `sh install.sh`
    - `sh link.sh`
4. Enjoy simulation!
    - `source $HOME/materiapps/hphi/hphivars.sh`
    - `HPhi --version`

# License and Copyright

The University of Tokyo holds the copyright of MateriApps Installer, and it is distributed under the GNU General Public License version 3 (GPL v3). The patch files for each installed software are subject to the license of the respective software.

(c) 2013-2021 The University of Tokyo. All rights reserved.

The development of the MateriApps Installer has been supported greatly by PASMUS software development project in FY2020 by Institute for Solid State Physics, the University of Tokyo.
