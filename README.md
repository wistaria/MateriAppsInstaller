MateriApps Installer
============================

Install script collection for MateriApps Software

MateriApps Installerの設計ポリシー
=====================================

* 特殊なツールに依存しない (shell, make, tarなどがあればOK)
* 古いバージョンを残せるようにする
* インストールとリンクの張替えを分ける (リンクの張替えを行うまでは、他に影響を与えない)
* 一時的に違う場所にインストールしてテストできるように

Setup
=========

* インストール場所
  * default では $HOME/materiapps の下にインストールされる
  * インストール場所を変更するには、$HOME/.mainstaller の中で設定する
      * PREFIX=...      # ツールとアプリを同じ場所にインストールする場合
      * PREFIX_TOOL=... # ツールのインストール場所
      * PREFIX_APPS=... # アプリケーションのインストール場所
      * SUDO=/usr/bin/sudo # インストールに root 権限が必要な場合
      * BUILD_DIR=...      # build を行う場所 (デフォルト $HOME/build)
      * SOURCE_DIR=...     # source tarball 置き場 (デフォルト $HOME/source)

* インストールするディレクトリ(上記 PREFIX, PREFIX_TOOL, PREFIX_APPS で指定したディレクトリ)を作成

* Mac OS X (Marvericks)のコンパイル環境設定 https://github.com/wistaria/installer/wiki/Marvericks

インストール
=============

* 下記「国内のスパコンへのインストール状況」を見ながら、番号の小さいものから順番にスクリプトを実行していく
  * 表で「○」となっている場合: default.sh を実行
  * 表に「○」以外(例: fx10)が記載されている場合: 対応するスクリプト(例: fx10.sh)を実行
* インストールが完了したら link.sh を実行

利用方法
=============

* ツール類(cmake, hdf5, python他)
   * source $PREFIX_TOOL/env.sh を実行
   * あるいは、shell の初期化スクリプトに同じ内容を書いておく
* アプリケーション(alps, openmx, modylas他)
   * アプリ毎にスクリプトを使って環境変数(PATHなど)を設定する
   * 例) alpsの場合: source $PREFIX_APPL/alps/alpsvar.sh
* インストールのテスト方法
   * 整備中
   
Status
=========

* 国内のスパコンへのインストール状況 Installation Status
    * ツール類 Tools https://docs.google.com/spreadsheet/pub?key=0Aj5PAnoVBnOedDM0ZVdVenNpdXctTGpBY3FkZHhNU2c&single=true&gid=1&output=html
    * アプリケーション Applications https://docs.google.com/spreadsheet/pub?key=0Aj5PAnoVBnOedDM0ZVdVenNpdXctTGpBY3FkZHhNU2c&single=true&gid=2&output=html
