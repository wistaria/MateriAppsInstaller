.. MA-Installer documentation master file, created by
   sphinx-quickstart on Sun May 10 14:29:22 2020.
   You can adapt this file completely to your liking, but it should at least
   contain the root `toctree` directive.

MateriApps Installerの概要
------------------------------------------
MateriApps Installerは様々な計算機環境に対応した計算物質科学アプリケーションのインストール補助を行うシェルスクリプト集である。MateriApps Installerには、オープンソースの計算物質科学アプリケーションやツール類を、macOSをはじめ、Linux PCやクラスタワークステーション、さらには国内の主要なスパコンシステムにインストールするためのシェルスクリプトが含まれる。MateriApps Installerは、東京大学物性研究所の全国共同利用スパコンにおいて、主要アプリケーションのプレインストールにも利用されている(インストールされているソフトウェア一覧はアプリ一覧に記載されている)。


開発の背景
------------------------------------------
今日では物質科学の理論研究を推し進めていく上でコンピュータを用いた数値計算は必要不可欠な存在となっている。計算物質科学を進めていくためには、物質科学の方程式を効率的に解くためのアルゴリズムの開発が重要な役割を果たしており、効率的なアルゴリズム・優れた並列性能・最先端の機能などを有する優れたアプリケーションが数多く生まれている。我々は開発されたソフトウェアについての情報を実験家・企業研究者などにも広く伝えるため、2013年より物質科学シミュレーションのポータルサイト `MateriApps <https://ma.issp.u-tokyo.ac.jp>`_ を公開し、国内外で開発された物質科学アプリケーションの情報を発信してきた。

利用者が物質科学の公開アプリケーションを使い始めようとする際に障害となるのは、ソフトウェアのインストール作業である。そこで手持ちのノートPCなどを用いて、気軽に計算物質科学アプリケーションを試せすことができる環境 `MateriApps LIVE! <https://cmsi.github.io/MateriAppsLive/>`_ の開発・公開も行っている。MateriApps LIVE!は、MateriAppsアプリケーション、OS (Debian GNU/Linux)、エディタ、可視化ツールなど、チュートリアルを始めるのに必要な環境がVirtualBoxの仮想ハードディスクイメージ(OVA)としてまとめられている。MateriApps LIVE!を用いることで、授業やソフトウェア講習会などで参加者の計算機環境を簡単に構築することが可能である。

しかしながら、実用向けの計算を行うにはMateriApps LIVE!の計算環境では非力である。物性研スーパーコンピュータなどの国内の主要なスーパーコンピュータから各研究室のクラスター計算機、個人のPCなど、幅広い計算環境において計算物質科学アプリケーションを利用者が手軽にインストールできるよう、MateriApps Installerの開発が開始された。


目標
------------------------------------------
MateriApps Installerの目標は下記の通りである。

-  計算物質科学分野に共通するアプリ(cf. `MateriApps <https://ma.issp.u-tokyo.ac.jp>`_)を国内(外)の主要なスパコン全てにインストールする。
-  同様にCentOS (RedHat), Debian (Ubuntu)の標準的な環境、macOS環境にもインストールできるスクリプトを整備する。


整備されているツールとアプリ
------------------------------------------

2020/12/4現在、以下のツール・アプリが整備されています (``config`` で ``default.sh`` 以外に用意されているものも一緒に記載しています)。

1. ツール

..
  boost, cmake, eigen3, fftw, gcc10, gcc7,
  git, gsl, hdf5, lapack, libffi, openmpi, openssl,
  python2, python3, scalapack, tcltk, zlib

.. csv-table::
   :file: ../../../table/tool.csv
   :encoding: euc-jp
   :header-rows: 1

2. アプリ

.. csv-table::
   :file: ../../../table/apps.csv
   :encoding: euc-jp
   :header-rows: 1

..  ALPS, DSQSS, QUANTUM ESPRESSO, HΦ, Kω, LAMMPS, mVMC, OpenMX, RESPACK, TeNeS


3. 今後追加予定のアプリ

  abICS, DCore, ALPS-Core, TRIQS


設計ポリシー
------------------------------------------
MateriApps Installerの設計ポリシーは下記の通りである。

1.  特殊なツールに依存しないようにする (shell, make, tarなどがあればOK)。

2.  スパコンはそれぞれ特殊なので、あまりユニバーサルなインストーラを作ることは目指さず、例外には個別のスクリプトを作成することで対処する。

3.  ツールについては、Linux (RPM Package, Debian Package)やmacOS (Homebrew, Fink, MacPorts)ですでにパッケージとして用意されている場合には、そちらを使う。

4.  アプリのバージョンは、 `MateriApps LIVE! <http://cmsi.github.io/MateriAppsLive/release.html>`_ と揃える。必要なパッチもMateriApps LIVE!用のDebian Packageと共通とする。

5.  ツール・アプリ毎に別のフォルダを使う。その下にバージョン別のフォルダを準備する。

    - cmakeの場合の例

     .. code-block:: bash

	$PREFIX_TOOL/cmake/cmake-3.2.1-1


6. それぞれのツール・アプリ、バージョン用の環境変数設定スクリプトを準備する。

    - cmakeの場合の例

     .. code-block:: bash

   	$PREFIX_TOOL/cmake/cmakevars-3.2.1-1.sh

7.  ツールの環境変数設定スクリプトについては ``PREFIX_TOOL/env.d`` にリンクを張り、 ``PREFIX_TOOL/env.sh`` で一括設定されるように古いバージョンを残せるようにする。

8.  インストールとリンクの張替えを分ける (リンクの張替えを行うまでは、他に影響を与えない)。

9.  一時的に違う場所にインストールしてテストできるようにする。


開発者
------------------------------------------
MateriApps Installerは以下のメンバーで開発している。

- ver. 0.1
   - 藤堂 眞治 (東京大学 大学院理学系研究科/物性研究所)
   - 本山 裕一 (東京大学 物性研究所)
   - 吉見 一慶 (東京大学 物性研究所)
   - 加藤 岳生 (東京大学 物性研究所)

   
バージョン履歴
------------------------------------------

- 2020/12/04 ver. 0.1 リリース. 

ライセンス
--------------
MateriApps Installerの著作権は東京大学が所持しており、GNU General Public License version 3 (GPLv3)準じて配布しています。ただし、インストールされるソフトウェアへのパッチファイルについては、それぞれのソフトウェアのライセンスに準ずるものとします。

*(c) 2013-2021 The University of Tokyo. All rights reserved.*

MateriApps Installerの開発については、2020年度東京大学物性研究所ソフトウェア高度化プロジェクトから多大なる支援をいただきました。
