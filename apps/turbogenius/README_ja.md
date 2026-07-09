# TurboGenius

- <https://github.com/kousuke-nakano/turbogenius>
- 第一原理量子モンテカルロ（QMC）パッケージ TurboRVB の Python
  ラッパー。TurboRVB のジョブを Python から制御し、VMC・LRDMC・構造最適化
  などのハイスループット QMC ワークフローを実現する。

## 必要環境

- `python3` として **Python 3.8.11 以上**（推奨 3.9〜3.12）が PATH 上にある
  こと。TurboGenius はコンパイル済み依存（trexio, pymatgen）を導入するが、
  これらはビルド済み wheel を配布している。対応する wheel が無い Python では
  ソースビルドにフォールバックし、trexio が HDF5 等の開発ライブラリを要求して
  大抵失敗する。
- MateriApps prefix へ `pip install` で導入し、依存は導入時に PyPI から解決
  （ネットワーク必要）。
- `install.sh` は `numpy < 2` と `pandas < 2.2` を固定する。v0.2 は NumPy 2.0
  以前のリリースのため自身の要件 `numpy >= 1.20.1` に上限が無く、放置すると
  pip が NumPy 2.x を入れてしまう。またコンパイル済み依存の一部（例: trexio,
  pymatgen）が NumPy 1.x でビルドされた wheel を配布するため、スタック全体を
  NumPy 1.x ABI に揃える。揃えないと `import turbogenius` が NumPy の ABI
  エラーで停止する。

## 備考

- TurboGenius は Python の制御層のみを提供する。実際の QMC 計算には TurboRVB
  本体のバイナリ（`turborvb.x`, `prep.x` など）が別途必要で、これは
  <https://github.com/sissaschool/turborvb> からビルドする。
- `pyturbo` は **import 時に** `TURBORVB_ROOT` を参照するため、`import
  turbogenius` するだけでも設定が必須。生成される `turbogeniusvars.sh` は
  次の順で解決する: (1) 既に設定済みの `TURBORVB_ROOT`、(2) MateriApps の
  `turborvb` パッケージが導入済みなら、その `turborvbvars.sh` を自動 source
  してバイナリを含むバージョン付き `TURBORVB_ROOT` を設定、(3) いずれも無ければ
  素の `$MA_ROOT/turborvb`（import を通すだけ）。よって **`turborvb`
  パッケージを先に入れておけば十分**で、`turborvbvars.sh` を
  `turbogeniusvars.sh` より先に source する必要はない。MateriApps 外の
  TurboRVB を使う場合は、実計算の前に `TURBORVB_ROOT` を自分で export すること。
- `sh link.sh` 後、`source $MA_ROOT/turbogenius/turbogeniusvars.sh` で
  `turbogenius` コマンドを `PATH` に、パッケージを `PYTHONPATH` に通し、
  `TURBORVB_ROOT` を設定する。
- 物性研 ohtaka で動作確認済み（`numpy 1.26.4` / `pandas 2.1.4` で導入成功、
  `import turbogenius` 成功、`turbogenius` コマンドが usage を表示）。
