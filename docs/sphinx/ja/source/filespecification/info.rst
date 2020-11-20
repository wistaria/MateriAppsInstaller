.. highlight:: bash

インストール関連ファイル
------------------------------------------

ここでは、ソフトウェアのインストールに必要な各ファイルに関するフォーマットやルールなどを説明します。

version.sh
===========

ソフトウェアのバージョンを指定するためのスクリプト。

アンダースコア2つずつに挟まれた変数は他のスクリプト中で用いるための変数。

- ``<NAME>_VERSION``
  
  - ソフトウェアのバージョン

- ``<NAME>_MA_REVISION``

  - 同一バージョンに対して MAInstaller のスクリプトが改訂された場合、それを区別するための識別子

- ``__NAME__``

  - ディレクトリ名などに用いられる、ソフトウェアの名前
  - MAInstaller では、スタイルとして小文字に統一している

- ``__VERSION__``

  - ``<NAME>_VERSION`` を指定する

- ``__MA_REVISION__``

  - ``<NAME>_MA_REVISION`` を指定する

例 ::

  TENES_VERSION="1.1.2"
  TENES_MA_REVISION="0"

  __NAME__=tenes
  __VERSION__=${TENES_VERSION}
  __MA_REVISION__=${TENES_MA_REVISION}


install.sh
============

T.B.A.

download.sh
===========

ソースコードをインターネットから入手するためのスクリプト。

- ``$SOURCE_DIR`` にダウンロードする

  - 保存されたファイルはフォーマットに従ってリネームしておく

    - ソフトウェアごとの違いをできるだけ減らすため

  - 特に、バージョン番号は必ず付与し、区別可能にしておく

- すでにダウンロード済みの場合はスキップする

  - 外部アクセスできない環境の場合は、手動でファイルを置けるようにしてある

例 ::

    SCRIPT_DIR=$(cd "$(dirname $0)"; pwd)
    . $SCRIPT_DIR/../../scripts/util.sh
    . $SCRIPT_DIR/version.sh
    set_prefix

    if [ -f $SOURCE_DIR/${__NAME__}-${__VERSION__}.tar.gz ]; then :; else
      check wget https://github.com/issp-center-dev/TeNeS/archive/v${__VERSION__}.tar.gz -O $SOURCE_DIR/${__NAME__}-${__VERSION__}.tar.gz
    fi


setup.sh
===========

アーカイブファイルを展開するためのスクリプト。

- ``download.sh`` を実行してアーカイブファイルを取得する

  - すでにダウンロードされているかのチェックは ``download.sh`` が行う

- ``$SOURCE_DIR`` 内にあるアーカイブファイルを ``$BUILD_DIR`` に展開する

  - 展開後のディレクトリは、フォーマットに従ってリネームしておく

- ``patch`` ディレクトリ内にパッチファイルがある場合にはそれを適用する

例 ::

  SCRIPT_DIR=$(cd "$(dirname $0)"; pwd)
  . $SCRIPT_DIR/../../scripts/util.sh
  . $SCRIPT_DIR/version.sh
  set_prefix

  sh ${SCRIPT_DIR}/download.sh

  cd $BUILD_DIR
  if [ -d ${__NAME__}-${__VERSION__} ]; then :; else
    check mkdir -p ${__NAME__}-$__VERSION__
    tarfile=$SOURCE_DIR/${__NAME__}-${__VERSION__}.tar.gz
    sc=`calc_strip_components $tarfile README.md`
    check tar zxf $tarfile -C ${__NAME__}-${__VERSION__} --strip-components=$sc
    cd ${__NAME__}-$__VERSION__
    if [ -f $SCRIPT_DIR/patch/${__NAME__}-${__VERSION__}.patch ]; then
      patch -p1 < $SCRIPT_DIR/patch/${__NAME__}-${__VERSION__}.patch
    fi
  fi


link.sh
===========

設定ファイルのシンボリックリンクを作成するスクリプト。

- アプリケーションの場合とツールの場合でシンボリックリンクの作成先が異なる

  - アプリの場合は ``$MA_ROOT/$__NAME__/${__NAME__}vars.sh``

  - ツールの場合は ``$MA_ROOT/env.d/${__NAME__}vars.sh``

例 ::

  SCRIPT_DIR=$(cd "$(dirname $0)"; pwd)
  . $SCRIPT_DIR/../../scripts/util.sh
  . $SCRIPT_DIR/version.sh
  set_prefix

  . $MA_ROOT/env.sh

  VARS_SH=$MA_ROOT/${__NAME__}/${__NAME__}vars-$__VERSION__-$__MA_REVISION__.sh
  rm -f $MA_ROOT/${__NAME__}/${__NAME__}vars.sh
  ln -s $VARS_SH $MA_ROOT/${__NAME__}/${__NAME__}vars.sh


README.md
===========

T.B.A.



管理用ファイル (``scripts/`` )
--------------------------------

util.sh
=================

スクリプト内で使う関数を定義しているスクリプト。

check_prefix.sh
===================

T.B.A.


fix_dylib.sh
===================

T.B.A.


list_maversion.sh
===================

T.B.A.
