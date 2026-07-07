# SIESTA

**サポート対象外 (UNSUPPORTED)**: 本パッケージは現状のまま提供されます。
MateriApps Installer の CI ではテストされておらず、MateriApps チームの公式
サポート対象ではありません。問題が生じても SIESTA 開発元ではなくパッケージ
提供者に連絡してください。

- <https://siesta-project.org/>
- 数値原子軌道基底に基づく第一原理電子状態計算コード（DFT、オーダー N 対応、
  TranSIESTA/TBtrans による伝導計算を含む）。

## 必要環境

- CMake >= 3.20、pkg-config、Fortran/C コンパイラ、MPI、BLAS/LAPACK、ScaLAPACK
- `install.sh` 実行時にネットワークが必要（SIESTA 5.x は configure 時に
  内部ライブラリ libfdf, xmlf90, libpsml, libgridxc をダウンロードする）
- ScaLAPACK が自動検出されない場合は明示的に指定する:
  `SCALAPACK_LIBRARIES="-L/path/to/lib -lscalapack" sh install.sh`

## 備考

- ビルドは純 MPI（OpenMP 無効）。netCDF, libxc, ELSI/ELPA, flook, DFT-D3
  は同梱 config では無効。有効化する場合は `config/*/preprocess.sh` を編集
  すること（DFT-D3 とユニットテストは Intel ifort classic ではコンパイル
  できないため、intel モードでは無効のままにすること）。
- `config/intel` は OpenMPI ラッパー越しの Intel コンパイラ + MKL を想定
  （`MKLROOT` 必須）。この組み合わせは物性研 ohtaka で動作確認済み。
- `runtest.sh` は同梱の H2O サンプルを 1 MPI プロセスで実行する。
