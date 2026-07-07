#!/usr/bin/env python3
# coding: utf-8

import os

import h5py

# cite key (ASCII, no spaces) -> group name in materiapps_info.h5
apps_table = {"komega": "Kω", "alps": "ALPS", "xtapp": "xTAPP",
              "espresso": "QUANTUM ESPRESSO", "openmx": "OpenMX",
              "modylas": "MODYLAS", "gromacs": "Gromacs",
              "lammps": "LAMMPS", "dsqss": "DSQSS",
              "mvmc": "mVMC", "tapioca": "TAPIOCA",
              "xcrysden": "XCRYSDEN",
              "dcore": "DCore", "respack": "RESPACK",
              "tenes": "TeNeS"}

script_dir = os.path.dirname(os.path.abspath(__file__))

with h5py.File(os.path.join(script_dir, "materiapps_info.h5"), "r") as fr:
    with open(os.path.join(script_dir, "mainstaller.bib"), "w") as fw:
        for cite_key, group_name in apps_table.items():
            if group_name not in fr:
                print("Warning: '{}' not found in materiapps_info.h5; "
                      "skipped".format(group_name))
                continue
            group = fr[group_name]
            name = group["name"][()].decode()
            url = group["official_url"][()].decode()
            fw.write("\\bibitem{{{}}} {}, {}\n".format(cite_key, name, url))
