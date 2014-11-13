MateriApps Installer
============================

Install script collection for MateriApps Software

Setup
=========

* インストール場所
  * default では $HOME/materiapps の下にインストールされる
  * インストール場所を変更するには、$HOME/.mainstaller の中で設定する

        PREFIX=...      # ツールとアプリを同じ場所にインストールする場合
        PREFIX_TOOL=... # ツールのインストール場所
        PREFIX_APPS=... # アプリケーションのインストール場所
        SUDO=/usr/bin/sudo # インストールに root 権限が必要な場合
        BUILD_DIR=...      # build を行う場所 (デフォルト $HOME/build)

* インストールするディレクトリ(上記 PREFIX, PREFIX_TOOL, PREFIX_APPS で指定したディレクトリ)を作成

* Mac OS X (Marvericks)のコンパイル環境設定 https://github.com/wistaria/installer/wiki/Marvericks

Status
=========

* 国内のスパコンへのインストール状況 Installation Status https://docs.google.com/spreadsheet/pub?key=0Aj5PAnoVBnOedDM0ZVdVenNpdXctTGpBY3FkZHhNU2c&output=html
