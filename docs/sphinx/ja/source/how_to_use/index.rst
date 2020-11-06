********************************
利用方法
********************************

ダウンロード
============

- MateriApps Installerは以下の手順でダウンロードできる。
  
  - リリース版のダウンロード

    MateriApps Installerのリリースページ(URLを後日追加)に行き、zipファイルをダウンロードした後に展開する。
    リリースページからダウンロードするzipファイルには本マニュアルのpdf版も同封されている。

  - git を利用したダウンロード
    
    以下のコマンドを打つことで、MateriApps Installerのダウンロードが可能である。

     .. code-block:: bash

	git clone https://github.com/wistaria/MateriAppsInstaller.git

ディレクトリ構造
=================

- 展開後に得られるディレクトリの構造は以下の通りである。

  .. code-block:: bash

		  |─ setup
		  |─ apps
		  |─ docs
		  |─ tools
		  |─ check
		  |   |- k.sh
		  |   |- macos.sh
		  |   |- sekirei.sh
		  |   |─ zetta-gcc.sh
		  |   |- zetta-intel.sh
		  |─ check_prefix.sh
		  |─ fix_dylib.sh
		  |─ list_maversion.sh
		  |─ macosx
		  |   |─ install.sh
		  |   |─ ports.sh
		  |- README.md
		  |- util.sh


- setup, tools, apps内にあるディレクトリは以下のような構成になっている。

  .. code-block:: bash

	  -- software_name
		|- README.md
		|- download.sh
		|- link.sh
		|- setup.sh
		|- version.sh
		|- install.sh
		|- patch 
	  	|- config 
 

  各ファイルおよびディレクトリの説明を以下に記載する(詳細はファイル形式を参考のこと)。    

  - README.md (必須)

    - ソフトウェアの簡単な紹介や公式サイトの URL などが記載されている

  - download.sh (必須)

    - ソースコードアーカイブをダウンロードする

  - link.sh (必須)

    - インストールしたディレクトリや設定ファイルへのシンボリックリンクを作成する

  - setup.sh (必須)

    - 用意したソースコードアーカイブを展開し、（存在するなら）パッチを適用する

  - version.sh (必須)

    - ダウンロードするバージョンを指定する

  - install.sh (必須)

    - プログラムのビルドならびにインストールを行う

  - patch (optional)

    - パッチを格納するディレクトリ

  - config (optional)

    - Intel コンパイラを用いる場合など、デフォルト設定以外のインストールを行うための追加設定集

- また、上記以外にも以下のファイル・ディレクトリが用意されている。

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

-  MateriApps Installerによって導入されるアプリケーションのインストール場所の設定

   -  default では ``$HOME/materiapps`` の下にソフトウェアがインストールされる。
   -  インストール場所は、 ``$HOME/.mainstaller`` の中で以下のオプションを設定することで変更可能。

      .. csv-table:: テーブルのタイトル
	 :header: "オプション", "デフォルト", "説明"
	 :widths: 15, 15, 30

         ``PREFIX`` , ``$HOME/materiapps``,  ツールとアプリのインストール場所(両方とも同じ場所にインストールする場合)
         ``PREFIX_TOOL`` , ``$HOME/materiapps`` ,ツールのインストール場所
         ``PREFIX_APPS`` , ``$HOME/materiapps`` ,アプリのインストール場所
         ``BUILD_DIR`` , ``$HOME/build`` ,build を行う場所
         ``SOURCE_DIR`` , ``$HOME/source`` ,source tarballの置き場

-  インストールするディレクトリ(上記 ``PREFIX``, ``PREFIX_TOOL``, ``PREFIX_APPS`` で指定したディレクトリ)は新たに作成される

インストール
============

-  各アプリケーションごとにinstall.shを実行する。

    - 各アプリケーションのconfigサブフォルダの下にインストールに対応しているコンパイラ名でサブディレクトリがある(gcc, intelなど)。
    - 該当するコンパイラを指定したい場合にはinstall.sh の後に, コンパイラ名を追加する。以下にgccでコンパイルする例を記載する。
      
      .. code-block:: bash

         sh install.sh gcc


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

	 source $PREFIX_ALPS/alps/alpsvar.sh

-  インストールのテスト方法

   -  整備中

-  サンプルバッチスクリプト

   -  整備中
