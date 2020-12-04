macOS 10.13 (High Sierra)へのインストール
------------------------------------------------------------

本節では、MacOS 10.13 (High Sierra)でMateriApps Installerを利用する方法を記載します。本チュートリアルは、MateriApps 開発チームにより執筆された記事をベースにしています。

基本情報
****************************

基本的な設定は以下のとおりです。

-  インストール先 (PREFIX)

   -  $HOME/materiapps

-  ビルドディレクトリ

   -  $HOME/build

-  C++1yのサーポート: あり
-  コンパイラ

   -  gcc 7.3 (from MacPorts)

-  MPI

   -  OpenMPI (from MacPorts)

-  CMake

   -  version 3.11 (from MacPorts)

-  BLAS/LAPACK

   -  Accelerate Framework

-  HDF5

   -  version 1.10

-  Python

   -  version 2.7 and version 3.6 (from MacPorts)

-  Git

   -  Use git 2.15 in macOS

ディレクトリ
**************************

-  $HOME/materiapps を作成

   .. raw:: html

      <div class="hcb_wrap">

   .. code:: prism

       $ mkdir -p $HOME/materiapps

   .. raw:: html

      </div>

-  $HOME/build を作成

   .. raw:: html

      <div class="hcb_wrap">

   .. code:: prism

       $ mkdir -p $HOME/build

   .. raw:: html

      </div>

-  $HOME/source を作成

   .. raw:: html

      <div class="hcb_wrap">

   .. code:: prism

       $ mkdir -p $HOME/source

   .. raw:: html

      </div>

MateriApps Installer のダウンロード
**********************************************************************

.. raw:: html

   <div class="hcb_wrap">

.. code:: prism

    $ cd $HOME/build 
        $ wget -O https://github.com/wistaria/MateriAppsInstaller/archive/master.tar.gz | tar zxvf - 
        $ mv MateriAppsInstaller-master MateriAppsInstaller

.. raw:: html

   </div>

Xcodeのインストール
*******************

-  App Store から Xcode をインストール
-  Xcodeのライセンスに同意

   .. raw:: html

      <div class="hcb_wrap">

   .. code:: prism

       sudo xcodebuild -license

   .. raw:: html

      </div>

-  Xcodeコマンドラインツールをインストール

   .. raw:: html

      <div class="hcb_wrap">

   .. code:: prism

       sudo xcode-select **install

   .. raw:: html

      </div>

MacPortsのインストール
**********************

-  https://www.macports.org/install.php からHigh
   Sierra用のインストーラをダウンロード・インストール
-  必要なports (GCC, OpenMPI, Python, CMake, HDF5, wget,
   git他)をインストール

   .. raw:: html

      <div class="hcb_wrap">

   .. code:: prism

       sudo sh $HOME/build/MateriAppsInstaller/macosx/ports.sh

   .. raw:: html

      </div>

MateriApps Installerによるツールのインストール
*****************************************************************************************

-  00_env

   .. raw:: html

      <div class="hcb_wrap">

   .. code:: prism

       $ sh $HOME/build/MateriAppsInstaller/00_env/default.sh

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

-  25_boost

   .. raw:: html

      <div class="hcb_wrap">

   .. code:: prism

       $ sh $HOME/build/MateriAppsInstaller/25_boost/macos.sh 
       $ sh $HOME/build/MateriAppsInstaller/25_boost/link.sh

   .. raw:: html

      </div>

-  40_alpscore

   .. raw:: html

      <div class="hcb_wrap">

   .. code:: prism

       $ sh $HOME/build/MateriAppsInstaller/40_alpscore/default_cxx1y.sh 
       $ sh $HOME/build/MateriAppsInstaller/40_alpscore/link.sh

   .. raw:: html

      </div>

-  70_alps

   .. raw:: html

      <div class="hcb_wrap">

   .. code:: prism

       $ sh $HOME/build/MateriAppsInstaller/70_alps/macos.sh 
       $ sh $HOME/build/MateriAppsInstaller/70_alps/link.sh

   .. raw:: html

      </div>

-  72_openmx

   .. raw:: html

      <div class="hcb_wrap">

   .. code:: prism

       $ sh $HOME/build/MateriAppsInstaller/72_openmx/macos.sh 
       $ sh $HOME/build/MateriAppsInstaller/72_openmx/link.sh

   .. raw:: html

      </div>

-  78_hphi

   .. raw:: html

      <div class="hcb_wrap">

   .. code:: prism

       $ sh $HOME/build/MateriAppsInstaller/78_hphi/macos.sh 
       $ sh $HOME/build/MateriAppsInstaller/78_hphi/link.sh

   .. raw:: html

      </div>

使い方
*******************

-  Tools (python, python3, etc) の設定を行う

   .. raw:: html

      <div class="hcb_wrap">

   .. code:: prism

       $ source $HOME/materiapps/env.sh

   .. raw:: html

      </div>

   Bashの設定ファイル($HOME/.bash_profile)に書いておくと良い
-  インストールされているバージョンの確認

   .. raw:: html

      <div class="hcb_wrap">

   .. code:: prism

       $ check_maversion

   .. raw:: html

      </div>

-  ALPS の実行環境を設定

   .. raw:: html

      <div class="hcb_wrap">

   .. code:: prism

       $ source $HOME/materiapps/alps/alpsvars.sh

   .. raw:: html

      </div>

-  HΦ の実行環境を設定

   .. raw:: html

      <div class="hcb_wrap">

   .. code:: prism

       $ source $HOME/materiapps/hphi/hphivars.sh

   .. raw:: html

      </div>

-  OpenMX の実行環境を設定

   .. raw:: html

      <div class="hcb_wrap">

   .. code:: prism

       $ source $HOME/materiapps/openmx/openmxvars.sh

   .. raw:: html

      </div>
