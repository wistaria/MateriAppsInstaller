# CrySPY

- <https://tomoki-yamashita.github.io/CrySPY_doc/>
- Python で書かれた結晶構造探索ツール。構造生成（ランダム、進化的アルゴリズム、
  ベイズ最適化、LAQA など）と外部のエネルギー計算コード（VASP, Quantum
  ESPRESSO, OpenMX, soiap, ASE など）を組み合わせて安定構造を探索する。

## 必要環境

- `python3` として **Python 3.9〜3.12** が PATH 上にあること。CrySPY は
  pyxtal / pymatgen / pyshtools を導入するが、pyshtools はこれらのバージョン
  向けにビルド済み wheel を配布している。EOL の Python 3.8（および pyshtools
  の wheel がまだ無い新しすぎる Python）では pyshtools がソースビルドに
  フォールバックし、fftw3 / openblas の開発ライブラリを要求して大抵失敗する。
- MateriApps prefix へ `pip install` で導入し、依存は導入時に PyPI から解決
  （ネットワーク必要）。
- `install.sh` は `numpy < 2` と `pandas < 2.2` を固定する。コンパイル済み依存
  の一部（例: pyshtools）が NumPy 1.x でビルドされた wheel を配布するため、
  スタック全体を NumPy 1.x ABI に揃える。揃えないと `cryspy` コマンドが import
  時に NumPy 1.x/2.x の ABI エラーで停止する。

## 備考

- CrySPY 自体は探索の制御のみを行う。実際の構造予測には本インストーラの
  Quantum ESPRESSO / OpenMX などのエネルギー計算コードと `cryspy.in` が必要。
- `sh link.sh` 後、`source $MA_ROOT/cryspy/cryspyvars.sh` で `cryspy` コマンドを
  `PATH` に、パッケージを `PYTHONPATH` に通す。
- 物性研 ohtaka の Python 3.9 で動作確認済み（`import cryspy` 成功、`cryspy`
  コマンドが `Start CrySPY 1.4.3` で起動）。
