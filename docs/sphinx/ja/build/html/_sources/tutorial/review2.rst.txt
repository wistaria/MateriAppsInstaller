物性研システムC(enaga)へのインストール
------------------------------------------------------------


本チュートリアルは、MateriApps 開発チームにより執筆されたものです。

Basic information / 基本情報
****************************

-  Install target directory / インストール先 (PREFIX)

   -  /home/issp/materiapps/intel18.0-gcc7.2-cxx1y

-  Build directory / ビルドディレクトリ

   -  $HOME/build

-  Support of C**1y / C**1yサーポート: Yes
-  Compiler / コンパイラ

   -  module intel/18.0.3 (for compilation of applications /
      アプリケーションコンパイル用)
   -  module gcc/7.2.0 (for compilation of tools / ツールコンパイル用)

-  MPI

   -  module mpt/2.17 (MPI Library / MPIライブラリ)

-  CMake

   -  module cmake/3.9.4

-  BLAS/LAPACK

   -  module intel-mkl/18.0.3 (MKL Library / MKLライブラリ)

-  HDF5

   -  Use MateriApps Installer / MateriApps Installer でインストールする

-  Python

   -  Use MateriApps Installer / MateriApps Installer でインストールする

-  Git

   -  Use git 2.14.3 installed by default /
      デフォルトでインストールされている git 2.14.3 を使う

Download of MateriApps Installer / MateriApps Installer のダウンロード
**********************************************************************

.. raw:: html

   <div class="hcb_wrap">

.. code:: prism

    $ mkdir -p $HOME/build 
    $ cd $HOME/build 
    $ wget -O https://github.com/wistaria/MateriAppsInstaller/archive/master.tar.gz | tar zxvf - 
    $ mv MateriAppsInstaller-master MateriAppsInstaller

.. raw:: html

   </div>

Configuration files / 設定ファイル
**********************************

-  Create $HOME/.mainstaller / $HOME/.mainstaller を作成

   .. raw:: html

      <div class="hcb_wrap">

   .. code:: prism

       $ cat << EOF > $HOME/.mainstaller 
       PREFIX=/home/issp/materiapps/intel18.0-gcc7.2-cxx1y 
       EOF

   .. raw:: html

      </div>

-  Create /home/issp/materiapps/intel18.0-gcc7.2-cxx1y/env.d/00_local.sh
   / /home/issp/materiapps/intel18.0-gcc7.2-cxx1y/env.d/00_local.sh
   を作成

   .. raw:: html

      <div class="hcb_wrap">

   .. code:: prism

       $ mkdir -p /home/issp/materiapps/intel18.0-gcc7.2-cxx1y/env.d/ 
       $ cat << EOF > /home/issp/materiapps/intel18.0-gcc7.2-cxx1y/env.d/00_local.sh 
       eval \`/usr/bin/modulecmd bash remove intel gcc mpt intel-mkl cmake\` 
       eval \`/usr/bin/modulecmd bash load intel/18.0.3 gcc/7.2.0 mpt/2.17 intel-mkl/18.0.3 cmake/3.9.4\` 
       eval \`/usr/bin/modulecmd bash list\` 
       EOF

   .. raw:: html

      </div>

Install tools using MateriApps Installer / MateriApps Installerによるツールのインストール
*****************************************************************************************

-  00_env

   .. raw:: html

      <div class="hcb_wrap">

   .. code:: prism

       $ sh $HOME/build/MateriAppsInstaller/00_env/default.sh

   .. raw:: html

      </div>

-  10_hdf5

   .. raw:: html

      <div class="hcb_wrap">

   .. code:: prism

       $ sh $HOME/build/MateriAppsInstaller/10_hdf5/default.sh 
       $ sh $HOME/build/MateriAppsInstaller/10_hdf5/link.sh

   .. raw:: html

      </div>

-  11_eigen3

   .. raw:: html

      <div class="hcb_wrap">

   .. code:: prism

       $ sh $HOME/build/MateriAppsInstaller/11_eigen3/default.sh 
       $ sh $HOME/build/MateriAppsInstaller/11_eigen3/link.sh

   .. raw:: html

      </div>

-  20_python

   .. raw:: html

      <div class="hcb_wrap">

   .. code:: prism

       $ sh $HOME/build/MateriAppsInstaller/20_python/intel-mkl.sh 
       $ sh $HOME/build/MateriAppsInstaller/20_python/link.sh

   .. raw:: html

      </div>

-  21_python3

   .. raw:: html

      <div class="hcb_wrap">

   .. code:: prism

       $ sh $HOME/build/MateriAppsInstaller/21_python3/intel-mkl.sh 
       $ sh $HOME/build/MateriAppsInstaller/21_python3/link.sh

   .. raw:: html

      </div>

-  25_boost

   .. raw:: html

      <div class="hcb_wrap">

   .. code:: prism

       $ sh $HOME/build/MateriAppsInstaller/25_boost/intel.sh 
       $ sh $HOME/build/MateriAppsInstaller/25_boost/link.sh

   .. raw:: html

      </div>

-  40_alpscore

   .. raw:: html

      <div class="hcb_wrap">

   .. code:: prism

       $ sh $HOME/build/MateriAppsInstaller/40_alpscore/intel_cxx1y.sh 
       $ sh $HOME/build/MateriAppsInstaller/40_alpscore/link.sh

   .. raw:: html

      </div>

-  70_alps

   .. raw:: html

      <div class="hcb_wrap">

   .. code:: prism

       $ sh $HOME/build/MateriAppsInstaller/70_alps/intel-mkl.sh 
       $ sh $HOME/build/MateriAppsInstaller/70_alps/link.sh

   .. raw:: html

      </div>

-  72_openmx

   .. raw:: html

      <div class="hcb_wrap">

   .. code:: prism

       $ sh $HOME/build/MateriAppsInstaller/72_openmx/intel-mkl.sh 
       $ sh $HOME/build/MateriAppsInstaller/72_openmx/link.sh

   .. raw:: html

      </div>

-  78_hphi

   .. raw:: html

      <div class="hcb_wrap">

   .. code:: prism

       $ sh $HOME/build/MateriAppsInstaller/78_hphi/intel.sh 
       $ sh $HOME/build/MateriAppsInstaller/78_hphi/link.sh

   .. raw:: html

      </div>

How to use / 使い方
*******************

-  Tools (python, python3, etc)

   .. raw:: html

      <div class="hcb_wrap">

   .. code:: prism

       $ source /home/issp/materiapps/intel18.0-gcc7.2-cxx1y/env.sh

   .. raw:: html

      </div>

   Bashの設定ファイル($HOME/.bash_profile)に書いておくと良い
-  Check version of installed software /
   インストールされているバージョンの確認

   .. raw:: html

      <div class="hcb_wrap">

   .. code:: prism

       $ check_maversion

   .. raw:: html

      </div>

-  ALPS

   .. raw:: html

      <div class="hcb_wrap">

   .. code:: prism

       $ source /home/issp/materiapps/intel18.0-gcc7.2-cxx1y/alps/alpsvars.sh

   .. raw:: html

      </div>

-  HΦ

   .. raw:: html

      <div class="hcb_wrap">

   .. code:: prism

       $ source /home/issp/materiapps/intel18.0-gcc7.2-cxx1y/hphi/hphi.sh

   .. raw:: html

      </div>

-  OpenMX

   .. raw:: html

      <div class="hcb_wrap">

   .. code:: prism

       $ source /home/issp/materiapps/intel18.0-gcc7.2-cxx1y/openmx/openmx.sh

   .. raw:: html

      </div>
