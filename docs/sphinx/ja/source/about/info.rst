.. MA-Installer documentation master file, created by
   sphinx-quickstart on Sun May 10 14:29:22 2020.
   You can adapt this file completely to your liking, but it should at least
   contain the root `toctree` directive.

概要
------------------------------------------
オープンソースの計算物質科学アプリケーションやツール類を、macOSをはじめ、Linux PCやクラスタワークステーション、さらには国内の主要なスパコンシステムにインストールするためのシェルスクリプト集。東大物性研の全国共同利用スパコンでも、MateriApps Installerを用いて主要アプリケーションがプレインストールされている。

目標
------------------------------------------

-  計算物質科学分野に共通するアプリ(cf. `MateriApps <http://ma.cms-initiative.jp>`_)を国内(外)の主要なスパコン全てにインストールする
-  同様にCentOS (RedHat), Debian (Ubuntu)の標準的な環境、Mac OS
   X環境にもインストールできるスクリプトを整備


設計ポリシー
------------------------------------------


1.  特殊なツールに依存しない (shell, make, tarなどがあればOK)
2.  スパコンはそれぞれ特殊なので、あまりユニバーサルなインストーラを作ることは目指しても仕方がない。例外には個別のスクリプトを作成することで対処
3.  ツールは、Linux (RPM Package, Debian Package)やMac OS X (MacPorts)ですでにパッケージとして用意されている場合にはそちらを使う
4.  アプリのバージョンは、 `MateriApps LIVE! <http://cmsi.github.io/MateriAppsLive/release.html>`_ と揃える。必要なパッチもMateriApps LIVE!用のDebian Packageと共通とする
5.  ツール・アプリ毎に別のフォルダを使う。その下にバージョン別のフォルダを準備

   - cmakeの場合の例

     .. code-block:: bash

	$PREFIX_TOOL/cmake/cmake-3.2.1-1

6. それぞれのツール・アプリ、バージョン用の環境変数設定スクリプトを準備

   - cmakeの場合の例
   
     .. code-block:: bash

	$PREFIX_TOOL/cmake/cmakevars-3.2.1-1.sh



7.  ツールの環境変数設定スクリプトについては ``PREFIX_TOOL/env.d`` にリンクを張り、 ``PREFIX_TOOL/env.sh`` で一括設定されるように古いバージョンを残せるようにする
8.  インストールとリンクの張替えを分ける (リンクの張替えを行うまでは、他に影響を与えない)
9.  一時的に違う場所にインストールしてテストできるようにする


開発者
------------------------------------------
MateriApps Installerは以下のメンバーで開発しています.

- ver. xxx
   - 藤堂 眞治 (東京大学大学院 理学系研究科)
   - 本山 裕一 (東京大学 物性研究所)
   - 吉見 一慶 (東京大学 物性研究所)
   - 加藤 岳生 (東京大学 物性研究所)

   
バージョン履歴
------------------------------------------

- 2020/xx/yy ver. 1.0 リリース. 

ライセンス
--------------
本ソフトウェアのプログラムパッケージおよびソースコード一式はGNU General Public License version 3（GPL v3）に準じて配布されています。ただし、各ソフトウェアのパッチファイルについては、各ソフトウェアのライセンスに準ずるものとしています。

コピーライト
------------------

*(c) 2020- The University of Tokyo. All rights reserved.*

本ソフトウェアは2020年度 東京大学物性研究所 ソフトウェア高度化プロジェクトの支援を受け開発されており、その著作権は東京大学が所持しています。
