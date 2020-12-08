# MateriApps Installer

Install script collection for MateriApps Software

# Document

- [English](https://wistaria.github.io/MateriAppsInstaller/manual/master/en/index.html)
- [日本語](https://wistaria.github.io/MateriAppsInstaller/manual/master/ja/index.html)

# Quick Usage

1. Specify install direcoty
    - `echo MA_ROOT=$HOME/materiapps` > ~/.mainstaller
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

MA Installer scripts are available under the GNU GPL v3, except for patch files for each software package (`patch/*.patch`).
Each patch file is distributed under the license of the original OSS project.

(c) 2020- The University of Tokyo. All rights reserved.

This software has been developed under the Project for advancement of software usability in material science by Institute for Solid State Physics, The University of Tokyo, and the copyright of this software belongs to the University of Tokyo.
