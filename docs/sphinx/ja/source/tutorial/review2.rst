Linuxへのインストール(gcc利用)
------------------------------------------------------------

本節では、LinuxOS上でMateriApps Installerを利用する方法を記載します。
動作確認はCentOS 7, Ubuntu 20 で行っています。(他のディストリビューションでも同じ手順でインストール可能のはずです。)
ツール類(gcc,cmakeなど)はあらかじめOSにインストールされているものを用いても構いませんが、万一何らかのトラブルが生じたときにエラーメッセージから原因を推測し適切に対応する必要があります。この作業に自信がない方は、すべてのツールをMateriApps Installerによってインストールすることをお勧めします。

初期セットアップ
****************************

まず最初のセットアップ(必要なディレクトリを作成するなど)を行います。
MateriApps Installerのディレクトリにはいり、

   .. raw:: html

      <div class="hcb_wrap">

   .. code:: prism

	$ sh setup/setup.sh

   .. raw:: html

      </div>

を実行します。この作業は最初に一回だけ行えば十分です。

gccのインストール
****************************

まずコンパイラをインストールします。(あらかじめLinuxOSにインストールされているgccコンパイラを用いて以降のツール・アプリをインストールすることも可能ですが、一部のアプリは古いgccコンパイラではうまくインストールできません。トラブルの処理に慣れていない方以外は、MateriAppsInstallerでgccコンパイラを導入することをお勧めします。)
以下の手順でgcc10をインストールします。

   .. raw:: html

      <div class="hcb_wrap">

   .. code:: prism

	$ cd tools/gcc10
	$ sh install.sh
   .. raw:: html

      </div>

gcc10のインストールには長い時間がかかります。遠隔で計算機サーバなどにインストールする場合は、最後のコマンドは以下のように変更してバックグラウンドで実行するとよいかもしれません。

   .. raw:: html

      <div class="hcb_wrap">

   .. code:: prism

	$ sh install.sh > log &

   .. raw:: html

      </div>

この場合はインストール作業の進行状況は同じディレクトリに生成されるログをみるとわかります(例えばcat logを実行する)。
インストールが成功したら、以下のコマンドを実行します。

   .. raw:: html

      <div class="hcb_wrap">

   .. code:: prism

	$ sh link.sh	   

   .. raw:: html

      </div>

これにより、ツールを利用する際の初期設定を行うスクリプトのリンクが所定の場所($HOME/materiapps/env.d)にコピーされます。
最後にこのコピーされた設定ファイルを実行し、以降のツール・アプリで利用可能な状態にします。

   .. raw:: html

      <div class="hcb_wrap">

   .. code:: prism

	$ source $HOME/materiapps/env.sh

   .. raw:: html

      </div>

gcc10がうまくインストールできた場合は、gcc8はインストールする必要はありません。まれに古いLinux OSではgcc10のインストールに失敗する場合があります。その場合にのみ、gcc8をインストールしてください。インストール方法は最初にtools/gcc8に入る以外は上述と同じです。

cmakeのインストール
****************************

一部のアプリはcmakeを利用してインストールを行います。cmakeはあらかじめLinuxのディストリビューションに含まれることが多いですが、古いバージョンのcmakeを用いると、一部アプリのインストールに失敗する場合があります。バージョン3.6以降であれば問題ありません。cmakeをインストールするには、gccコンパイラをインストールした直後の状況で以下のコマンドを実行します。

   .. raw:: html

      <div class="hcb_wrap">

   .. code:: prism

	$ cd ../cmake
	$ sh install.sh
	$ sh link.sh
	$ source $HOME/materiapps/env.sh

   .. raw:: html

      </div>

その他のツールのインストール
****************************

同様の方法で残りのツールのインストールも行います。例えば、cmakeのインストール直後に、引き続いてgitをインストールする場合は、以下のコマンドを実行します。

   .. raw:: html

      <div class="hcb_wrap">

   .. code:: prism

	$ cd ../git
	$ sh install.sh
	$ sh link.sh
	$ source $HOME/materiapps/env.sh

   .. raw:: html

      </div>

すべてのツールをインストールする場合には、まずgit,python3,libffiを先にインストールし、残りのツールをアルファベット順(boost, eigen3, fftw, gsl, hdf5, lapack, libffi, openmpi, openssl, scalapack, tcltk, zlib)にインストールするとよいでしょう。(scalapackのインストールを行う前にopenmpiを先にインストールする必要があります。)コマンドは最初にはいるディレクトリ名をインストールしたツール名に変更する以外全く同じです。

アプリのインストール
**************************

ツール類のインストールが終了したら、下記のようにインストールしたいアプリのディレクトリに入り、ツールの実行環境設定を行ったあとに、インストールスクリプトを実行します。

   .. raw:: html

      <div class="hcb_wrap">

   .. code:: prism

	$ sh $HOME/materiapps/env.sh
	$ sh install.sh

   .. raw:: html

      </div>

正しくインストールされているかどうかは、各アプリのディレクトリで

   .. raw:: html

      <div class="hcb_wrap">

   .. code:: prism

	$ sh runtest.sh

   .. raw:: html

      </div>

を実行することで確認できます。(respackのruntest.shを実行する際には、あらかじめquantum ESPRESSOをインストールしておく必要があります。また次の節で述べる方法により、quantum ESPRESSOの実行環境を設定しておく必要があります。)

アプリのダウンロード・インストールの途中で一時停止すると、ソースファイルが残ったままになり、再度インストールを行ったときにうまくいかないことがあります。その場合は、ソースファイル(デフォルトではホームディレクトリのmateriapps/source以下）にある対象アプリのディレクトリを削除してください。

インストール時にエラーがでた場合は、エラーメッセージをよく見てください。多くの場合、必要なツール類がインストールされていないためにエラーが生じます。エラーメッセージから、必要となるツール類を読み取り、ツールのインストールを行ってください。

テストが無事終了したら、最後に以下のコマンドでアプリの環境設定ファイルを適切なファイル名でリンクします。

   .. raw:: html

      <div class="hcb_wrap">

   .. code:: prism

	$ sh link.sh

   .. raw:: html

      </div>


各アプリの実行環境の設定
**************************

アプリを実行するためには、実行環境の設定を行う必要があります。以下のコマンドを入力することにより、各アプリの実行環境を整え、すぐにアプリが実行できる環境を整備することができます。例えば、HΦをインストールしてある場合(インストールディレクトリがデフォルトのmateriappsであったとする)は、

   .. raw:: html

      <div class="hcb_wrap">

   .. code:: prism

	$ ls $HOME/materiapps/hphi

   .. raw:: html

      </div>

でファイルを表示させたときに、hphivars.shという名前の設定ファイルがあるはずです。この設定ファイルを下記のように実行し、実行環境の設定を行います。

   .. raw:: html

      <div class="hcb_wrap">

   .. code:: prism

	$ source $HOME/materiapps/hphi/hphivars.sh

   .. raw:: html

      </div>
