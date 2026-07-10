QUANTUM ESPRESSO
================

SUMMARY
-------

擬ポテンシャル法と平面波基底を用いた第一原理計算ライブラリ。広範な物理系に対して、密度汎関数法に基づく電子状態計算を高精度で行うことができる。基本プログラムのほかに多数のコアパッケージ・プラグインが含まれ、無償ながら研究・開発に利用できる多くの充実した機能を持つ。MPIによる並列計算にも対応している。

LICENSE
-------

GNU GPL v2

OFFICIAL PAGE
-------------

http://www.quantum-espresso.org/

MateriApps URL
--------------

https://ma.issp.u-tokyo.ac.jp/app/720

GPU ビルド（モード ``gpu``）
----------------------------

``sh install.sh gpu`` で NVIDIA GPU（CUDA / OpenACC）版を NVHPC コンパイラ
（``nvfortran`` / ``nvc``）と CUDA-aware MPI でビルドする（例: NVHPC/CUDA 環境で
``module load nvhpc openmpi_nvhpc``）。``nvfortran`` は既定でビルドノードの GPU を
対象にする。対象 GPU が無いノードでビルドする場合は
``MA_EXTRA_FLAGS="-gpu=ccXX"``（A100 なら ``cc80``）で compute capability を指定する。
本モードは NVIDIA GPU + CUDA 環境が必要で CI 対象外。物性研 kugui（A100）で
動作確認済み（``pw.x`` が "GPU acceleration is ACTIVE" を表示）。
