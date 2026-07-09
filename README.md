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

## Quick install with `ma.sh`

For apps that declare their tool dependencies, a single command builds the
missing tools (in dependency order) and then the app:

    sh ma.sh install hphi        # build cmake/openmpi/scalapack as needed, then HPhi
    sh ma.sh list                # available apps/tools ([deps] = auto-resolves tools)
    sh ma.sh installed           # what is already installed

Automatic dependency resolution applies only to apps tagged `[deps]` in
`sh ma.sh list`; for other apps `ma.sh` installs just that app and you install
its tools first (the per-directory flow below). `ma.sh` builds tools in their
default mode.

# License and Copyright

The University of Tokyo holds the copyright of MateriApps Installer, and it is distributed under the GNU General Public License version 3 (GPL v3). The patch files for each installed software are subject to the license of the respective software.

(c) 2013- The University of Tokyo. All rights reserved.

The development of the MateriApps Installer has been supported greatly by PASMUS software development project in FY2020 by Institute for Solid State Physics, the University of Tokyo.
