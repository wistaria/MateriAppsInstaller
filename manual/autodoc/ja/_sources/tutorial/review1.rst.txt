

macOS 10.15 (Catalina)へのインストール
------------------------------------------------------------

本節では、macOS 10.15 (Catalina)でMateriApps Installerを利用する方法を記載します。

ツールのインストール
****************************

toolsディレクトリにはいっているツール類は、macOSのパッケージ管理ソフト(Homebrew, Fink, MacPortsなど)を用いてインストールするほうが便利です。ここではHomebrewを用いる方法を紹介します。アプリのインストール先はデフォルトのままであるとします。インストール先は$HOME/materiapps, ビルドディレクトリは$HOME/buildになります。

まずhttps://brew.sh/にある情報に従ってインストールします。 ::

$ /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"

次にツール類をHomebrewによってインストールします。他の方法でインストールがすでになされている場合は、Homebrewでインストールする必要はありません。以下のツールははじめにすべてインストールしてもいいですし、アプリのインストールで要求されたときにインストールするようにしても構いません。 ::

$ brew install gcc
$ brew install boost
$ brew install cmake
$ brew install eigen
$ brew install fftw
$ brew install git
$ brew install gsl
$ brew install hdf5
$ brew install lapack
$ brew install libffi
$ brew install openblas
$ brew install openmpi
$ brew install openssl
$ brew install python@3
$ brew install scalapack
$ brew install tcl-tk
$ brew install zlib

またアプリによっては、以下のツールもインストールしておく必要があります。 ::

$ brew install svn
$ brew install boost-python
$ brew install boost-python3
$ brew install boost-mpi
$ brew install wget

さらにアプリによってはpythonのライブラリのインストールが必要な場合があります。以下のコマンドによってインストールしておきます。 ::

$ pip3 install numpy --user
$ pip3 install scipy --user
$ pip3 install toml --user

アプリのインストール
**************************

まず最初のセットアップ(必要なディレクトリを作成するなど)を行います。
MateriAppsInstallerのディレクトリにはいり、 ::

$ sh setup/setup.sh

を実行します。次にインストールしたいアプリのディレクトリに入り、 ::

$ CC=gcc-10 CXX=g++-10 FC=gfortran-10 CPP=cpp-10 sh install.sh

を実行すればインストールができるはずです。正しくインストールされているかどうかは、各アプリのディレクトリで ::

$ sh runtest.sh

を実行することで確認できます。(respackのruntest.shを実行する際には、予めquantum ESPRESSOをインストールしておく必要があります。また次の節で述べる方法により、quantum ESPRESSOの実行環境を設定しておく必要があります。)

アプリのダウンロード・インストールの途中で一時停止すると、ソースファイルが残ったままになり、再度インストールを行ったときにうまくいかないことがあります。その場合は、ソースファイル(デフォルトではホームディレクトリのmateriapps/source以下）にある対象アプリのディレクトリをすべて削除してください。

インストール時にエラーがでた場合は、エラーメッセージをよく見てください。多くの場合、必要なツール類がインストールされていないためにエラーが生じます。エラーメッセージから、必要となるツール類を読み取り、ツールのインストールを行ってください。

各アプリの実行環境の設定
**************************

アプリを実行するためには、実行環境の設定を行う必要があります。以下のコマンドを入力することにより、各アプリの実行環境を整え、すぐにアプリが実行できる環境を整備することができます。例えば、HΦをインストールしてある場合(インストールディレクトリがデフォルトのmateriappsであったとする)は、 ::

$ ls $HOME/materiapps/hphi

でファイルを表示させたときに、hphivars.shという名前の設定ファイルがあるはずです。この設定ファイルを下記のように実行し、実行環境の設定を行います。 ::

$ source $HOME/materiapps/hphi/hphivars.sh
