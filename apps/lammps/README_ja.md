# LAMMPS 

## SUMMARY 

 オープンソースの汎用古典分子動力学アプリケーション。ソフトマター、固体、メソスコピック系などの多くの系で動力学計算を行うことができる。原子の動力学計算や一般的な粒子のシミュレーターとしても利用可能で、空間分割を用いた並行計算にも対応する。GPLライセンスを採用し、コードは変更や拡張が容易となるようにデザインされている。

## LICENSE 

 GPLv2 

## OFFICIAL PAGE 

 https://lammps.sandia.gov

## MateriApps URL 

 https://ma.issp.u-tokyo.ac.jp/app/596


## GPU ビルド（モード `gpu`）

 `sh install.sh gpu` で NVIDIA GPU（KOKKOS / CUDA）版をビルドする。ビルド前に
 環境変数 `KOKKOS_ARCH` で対象 GPU アーキテクチャを指定する（必須・既定なし）:
 例として A100 なら `export KOKKOS_ARCH=AMPERE80`。代表値は `AMPERE80` (A100),
 `VOLTA70` (V100), `HOPPER90` (H100), `TURING75` (T4), `ADA89` (RTX 40),
 `PASCAL60` (P100)。誤ったアーキテクチャでもビルドは通るが GPU 実行時に失敗する。
 CUDA ツールキット（`nvcc`）と CUDA-aware MPI が `PATH` に必要。本モードは NVIDIA
 GPU が必要で CI 対象外。物性研 kugui（A100）で動作確認済み。
