********************************
利用方法
********************************

ダウンロード
============

- インストールスクリプト集であるMateriAppsInstallerは以下の手順でダウンロードできる。
  
  - リリース版のダウンロード。

    MateriAppsInstallerのリリースページ(URLを後日追加)に行き、zipファイルをダウンロードした後に展開する。
    なお、リリースページからダウンロードするzipファイルには本マニュアルのpdf版が同封されている。

  - git を利用してダウンロード。
    
    以下のコマンドを打つことで、MateriAppsInstallerのインストールが可能である。

     .. code-block:: bash

	git clone https://github.com/wistaria/MateriAppsInstaller.git

ディレクトリ構造
=================

- 展開後に得られるディレクトリの構造は以下の通りである。

  .. code-block:: bash

		  ├── 00_env
		  │   ├── default.sh
		  │   ├── fx10.sh
		  │   ├── install_cm.sh
		  │   ├── obsolete
		  │   │   ├── camphor.kudpc.kyoto-u.ac.jp
		  │   │   ├── kashiwa.issp.u-tokyo.ac.jp
		  │   │   └── tatara.cc.kyushu-u.ac.jp
		  │   └── version.sh
		  ├── 01_gcc7
		  │   ├── default.sh
		  │   ├── link.sh
		  │   ├── setup.sh
		  │   └── version.sh
		  .
		  .
		  .
		  ├── README.md
		  ├── check
		  │   ├── k.sh
		  │   ├── macos.sh
		  │   ├── sekirei.sh
		  │   ├── zetta-gcc.sh
		  │   └── zetta-intel.sh
		  ├── check_prefix.sh
		  ├── fix_dylib.sh
		  ├── list_maversion.sh
		  ├── macosx
		  │   ├── install.sh
		  │   └── ports.sh
		  └── util.sh


- ソフトウェア・ライブラリに関するディレクトリは以下のような構成になっている。

  .. code-block:: bash

	  -- software_name
		|- default.sh
		|- link.sh
		|- setup.sh
		|- version.sh
		|- patches 
	  	|- config 
		|- README.md
 

  各ファイルおよびディレクトリの説明を以下に記載する(詳細はファイル形式を参考のこと)。    

  - version.sh (必須)

    - ダウンロードするバージョンを指定する

  - download.sh (必須)

    - ソースコードアーカイブをダウンロードする

  - setup.sh (必須)

    - 用意したソースコードアーカイブを展開し、（存在するなら）パッチを適用する

  - default.sh (必須)

    - プログラムのビルドならびにインストールを行う

  - link.sh (必須)

    - インストールしたディレクトリや設定ファイルへのシンボリックリンクを作成する

  - patches (optional)

    - パッチを格納するディレクトリ

  - config (optional)

    - Intel コンパイラを用いる場合など、デフォルト設定以外のインストールを行うための追加設定集

  - README.md (必須)

    - ソフトウェアの簡単な紹介や公式サイトの URL などが記載されている

- また、上記以外にもxxxxのため、以下のファイル・ディレクトリが用意されている。

  - list_maversion.sh

    - 各ディレクトリ中にある version.sh の情報をまとめるスクリプト

  - util.sh

    - インストールディレクトリの設定など、スクリプト中で使うユーティリティ関数が定義されている

  - check_prefix.sh

    - インストール先のトップディレクトリなど、各スクリプト共通で用いられる変数を表示するスクリプト

  - checkディレクトリ

    - 各種ホストで複数のインストールスクリプトを順番に走らせるためのスクリプト

  - fix_dylib.sh

    - macOS で RPATH 情報を修正するためのスクリプト

  - macosxディレクトリ

    - Macports を用いて必要なツールをインストールするためのスクリプト


セットアップ
============

-  インストール場所の設定

   -  default では ``$HOME/materiapps`` の下にソフトウェアがインストールされる。
   -  インストール場所の変更は、 ``$HOME/.mainstaller`` の中で以下のオプションを設定することで可能。

      .. csv-table:: テーブルのタイトル
	 :header: "オプション", "デフォルト", "説明"
	 :widths: 15, 15, 30

         ``PREFIX`` , ``$HOME/materiapps``,  ツールとアプリのインストール場所(両方とも同じ場所にインストールする場合)
         ``PREFIX_TOOL`` , ``$HOME/materiapps`` ,ツールのインストール場所
         ``PREFIX_APPS`` , ``$HOME/materiapps`` ,アプリのインストール場所
         ``BUILD_DIR`` , ``$HOME/build`` ,build を行う場所
         ``SOURCE_DIR`` , ``$HOME/source`` ,source tarballの置き場

-  インストールするディレクトリ(上記 ``PREFIX``, ``PREFIX_TOOL``, ``PREFIX_APPS`` で指定したディレクトリ)を作成

インストール
============

-  下記「国内のスパコンへのインストール状況」を見ながら、番号の小さいものから順番にスクリプトを実行していく。

    - 国内のスパコンへのインストール状況
       - `ツール類 <https://docs.google.com/spreadsheets/u/0/d/1ykttehDs9vn8XljJ6YE0bwsdjBMjw5sGTjFkVMygjHs/pub?single=true&gid=1&output=html>`_ 
       - `アプリケーション <https://docs.google.com/spreadsheets/u/0/d/1ykttehDs9vn8XljJ6YE0bwsdjBMjw5sGTjFkVMygjHs/pub?single=true&gid=2&output=html>`_
       - 表で「○」となっている場合: default.sh を実行する。
       - 表に「○」以外(例: fx10)が記載されている場合: 対応するスクリプト(例: fx10.sh)を実行する。

    - インストールが完了したら link.sh を実行する。

- ソフトウェアのバージョン情報
    -  `バージョン情報 <https://1drv.ms/x/s!Aiwat40kj6WrmBHroPX3n3Uft8cO>`_ にあるMateriAppsInstallerの箇所に、現在対応しているソフトウェアのバージョン情報を記載している。


ツール・アプリの利用方法
==========================

-  ツール類(cmake, hdf5, python他)
   
   - 以下のコマンドを実行する(もしくはshell の初期化スクリプトに同じ内容を書いておく)。

     .. code-block:: bash

	source $PREFIX_TOOL/env.sh

-  アプリケーション(alps, openmx, modylas他)

   -  アプリ毎にスクリプトを使って環境変数(``PATH`` など)を設定する。
    
      例) alpsの場合:

      .. code-block:: bash

	 source $PREFIX_APPS/alps/alpsvar.sh

-  インストールのテスト方法

   -  整備中

-  サンプルバッチスクリプト

   -  整備中
