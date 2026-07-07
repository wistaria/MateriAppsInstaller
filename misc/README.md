# misc/ — maintenance scripts

Helper scripts for maintaining the MateriApps information used in
documentation. They are not part of the installer itself.

## Data source

- `materiapps_info.h5` / `materiapps_info_ja.h5` — scraped snapshots of
  the MateriApps portal (https://ma.issp.u-tokyo.ac.jp/).

## Scripts

| script | run from | input | output |
|---|---|---|---|
| `get_info.py` / `get_info_ja.py` | anywhere | MateriApps portal (network) | `materiapps_info.h5` (in cwd) |
| `make_bib.py` | anywhere | `misc/materiapps_info.h5` | `misc/mainstaller.bib` |
| `make_readme.py` / `make_readme_ja.py` | `apps/` (with the h5 file copied there) | `materiapps_info.h5` | `apps/*/README.md` |
| `make_rst.py` / `make_rst_ja.py` | `apps/` (with the h5 file copied there) | `materiapps_info.h5` | rst fragments |

Note: `make_readme*.py` and `make_rst*.py` still assume the current
directory contains `materiapps_info.h5`; only `make_bib.py` resolves
paths relative to the script location.

## Regenerating mainstaller.bib

`mainstaller.bib` is a committed generated artifact. After the portal
information changes (i.e. after rerunning `get_info.py`), regenerate it
with:

```sh
python3 misc/make_bib.py
```

and commit the result together with the updated `materiapps_info.h5`.

- `old/` — retired installer scripts kept for reference (see issue #185).
