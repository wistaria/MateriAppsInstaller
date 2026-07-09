# TurboRVB

- <https://github.com/sissaschool/turborvb>
- <https://sissaschool.github.io/turborvb_website/>
- 分子・固体電子系向けの第一原理量子モンテカルロ（QMC）パッケージ。共鳴原子価
  結合（RVB）波動関数に基づき、変分モンテカルロ（VMC）および格子正則化拡散
  モンテカルロ（LRDMC）計算を行う。

## 必要環境

- **CMake 3.20 以上**、**Fortran / C コンパイラ**（GNU, Intel oneAPI, NVHPC）、
  **BLAS / LAPACK**（Intel MKL があれば自動検出して利用）。
- 並列版のビルドには **MPI**（Fortran + C）が必要。既定ではシリアル版と並列
  （MPI）版の両方をビルドするが、MPI コンパイラが見つからない場合 CMake が
  自動的に並列ターゲットを外すため、本書が対象とするフルビルドには MPI
  環境が必要。ScaLAPACK は見つかればリンクされる（MKL ScaLAPACK または
  システムの ScaLAPACK）。

## ビルド

`install.sh` は既定オプション（`EXT_SERIAL=ON`, `EXT_PARALLEL=ON`、QMC + DFT +
tools）で out-of-source の CMake ビルドを行う。特定のコンパイラを使うには
`~/.mainstaller` または環境で `CC` / `FC` を設定する（CMake は `CC` / `FC` を
参照する）。`MA_EXTRA_FLAGS` は追加の C/Fortran フラグとして、`MAKE_J` は
並列 make の指定として渡される。

インストールされる実行ファイル（`$TURBORVB_ROOT/bin`）には QMC エンジン
（`turborvb-serial.x`, `turborvb-mpi.x`）、DFT prep（`prep-serial.x`,
`prep-mpi.x`）、各種ツール（`makefort10.x`, `readalles.x`,
`convertfort10-serial.x`, `readforward-serial.x` など）が含まれる。

## 備考

- `sh link.sh` 後、`source $MA_ROOT/turborvb/turborvbvars.sh` で TurboRVB の
  バイナリを `PATH` に通し、`TURBORVB_ROOT` を export する。
- **TurboGenius 連携:** TurboGenius（`apps/turbogenius`）の Python ラッパーは
  import 時に `TURBORVB_ROOT` を参照する。`turbogeniusvars.sh` より先に
  `turborvbvars.sh` を source すれば、TurboGenius がこの TurboRVB を利用する。
  TurboRVB v1.0.0 は一部のシリアルツールを `-serial` 付きで命名する
  （`convertfort10-serial.x` など）。TurboGenius のワークフローが接尾辞なしの
  名前を期待する場合は、対応する `TURBO*_RUN_COMMAND` 環境変数を設定する
  （`pyturbo/utils/env.py` 参照）。
- ライセンス: GNU GPL v3。
