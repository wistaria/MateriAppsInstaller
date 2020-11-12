.. highlight:: bash

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
    
    以下のコマンドを打つことで、MateriApps Installerのダウンロードが可能である。:: 

        git clone https://github.com/issp-center-dev/MateriAppsInstaller

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

- ソフトウェアのインストールを行う前に ``setup/setup.sh`` を実行する必要がある

  - ``sh setup/setup.sh``
  - このスクリプトは初期設定として、インストールディレクトリや作業用ディレクトリなどの作成を行う

-  MateriApps Installerによって導入されるアプリケーションのインストール場所の設定

  -  インストール場所は、次のように ``$HOME/.mainstaller`` ファイルで設定可能 ::

      # シェルスクリプトとして処理されるため、 = の前後に空白は置いてはいけない

      MA_ROOT=$HOME/materiapps  # ソフトウェアのインストール先
      BUILD_DIR=$HOME/build     # インストール作業場所
      SOURCE_DIT=$HOME/source   # ファイルダウンロード場所

    .. csv-table:: 
      :header: "オプション", "デフォルト", "説明"
      :widths: 15, 15, 30

        ``MA_ROOT`` , ``$HOME/materiapps``,  ソフトウェアのインストール先
        ``BUILD_DIR`` , ``$HOME/build`` , インストール作業場所
        ``SOURCE_DIR`` , ``$HOME/source`` , ソースコードアーカイブファイルのダウンロード場所

  - このファイルがない場合は ``$HOME/materiapps`` の下にソフトウェアがインストールされる
  - 実際のインストール場所は、以降で説明するインストール作業を行った時点での ``.mainstaller`` ファイルの内容が用いられることに注意

    - ``setup.sh`` を実行した時の情報ではないという意味

インストール
============

-  各ソフトウェアのディレクトリに移動し、 ``install.sh`` を実行する。 ::

    sh install.sh

  - ソースコードのダウンロード(``download.sh``)・展開(``setup.sh``)を行った後に、ビルドおよびインストールを行う
  - ソフトウェアによってはコンパイラやライブラリに対する設定が定義済みの場合があり、 ``config`` ディレクトリ以下にサブディレクトリとして収められている

    - ``sh install.sh intel`` のように、引数で与えることで使用可能

      - 存在しない設定ディレクトリを指定した場合、使用可能な設定の一覧を表示する ::

	  $ sh install.sh help
	  Error: unknown mode: help
	  Available list:
	  default
	  intel

    - ``default``

      - 引数を省略した場合に使用される、基本的な設定

    - ``intel``

      - Intel コンパイラ、 Intel MKL、 Intel MPI を使用するための設定

  - シェル変数を用いてコンパイラなどの指定が可能

    - （例）デフォルト設定を使いつつ C コンパイラとして Intel コンパイラを使いたい場合 ::

        CC=`which icc` sh install.sh

    - 特に、 ``MA_EXTRA_FLAGS`` を設定することでコンパイラオプションを追加可能 ::

        MA_EXTRA_FLAGS="-march=core-avx2" sh install.sh intel

    - ``CMAKE`` を用いて ``cmake`` コマンドのパスを指定可能

    - ``ISSP_UCOUNT`` は物性研スパコンにおける利用率測定スクリプトのパスであり、ほとんどのユーザは気にしなくて問題ない

    - そのほか、利用可能な変数は ``install.sh`` のはじめの方を参照のこと

- ``sh runtest.sh`` で簡易テストを実行可能

  - インストールディレクトリの存在確認
  - 設定ファイルの有効性確認
  - ソフトウェアが実際に動作するかの確認

- ソフトウェアは ``$MA_ROOT/NAME/NAME-VERSION-MA_REVISION`` ディレクトリにインストールされる

  - ``NAME``, ``VERSION`` はそれぞれソフトウェア名とバージョンに置き換わる

    - ``MA_REVISION`` は、ソフトウェアの同一バージョンに対して MateriApps Installer が改訂された場合に区別するための識別子
    - 例: ``hphi/hphi-3.4.0-1``

  - ソフトウェアと共に、環境変数などを設定する設定ファイル ``NAMEvars-VERSION-MA_REVISION.sh`` が ``$MA_ROOT/NAME/`` にインストールされる

    - 例: ``hphivars-3.4.0-1.sh`` 

    - ``sh link.sh`` を実行することで、 ``NAMEvars-VERSION.sh`` のシンボリックリンク ``NAMEvars.sh`` が作成される

      - アプリの場合は ``NAME`` 以下に作成される
      - ツールの場合は ``$MA_ROOT/env.d`` 以下に作成され、 ``$MA_ROOT/env.sh`` 内で読み込まれる

ツール・アプリの利用方法
==========================

-  ツール類(cmake, hdf5, python他)
   
   - 以下のコマンドを実行する(もしくはshell の初期化スクリプト (``.bashrc`` など)に同じ内容を書いておく)

     .. code-block:: bash

	source $MA_ROOT/env.sh

- アプリケーション(alps, openmx, modylas他)

  - アプリ毎に設定ファイルを読み込んで環境変数(``PATH`` など)を設定する
    
    例) alpsの場合::

        source $MA_ROOT/alps/alpsvars.sh
  
  - バージョンを固定したい場合は、そのバージョンの設定ファイルを用いる ::
      
      source $MA_ROOT/alps/alpsvar-20201106-r7860-1.sh
