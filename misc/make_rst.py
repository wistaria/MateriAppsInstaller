#!/usr/bin/python
# coding: utf-8

import h5py
import glob
import os
import re
import subprocess

path_to_sphinx = "../docs/sphinx/en/source/appendix/"
dirs_apps = [x for x in glob.glob("./*") if os.path.isdir(x)]

dirs_apps.sort()
print(dirs_apps)
cwd_path = os.getcwd()
path_to_sphinx = os.path.join(cwd_path, path_to_sphinx)


for dir_name in dirs_apps:
    path_to_README = os.path.join(dir_name, "README.md")
    if os.path.isfile(path_to_README):
        os.chdir(os.path.join(cwd_path, dir_name))
        print("OK {}".format(dir_name))
        cmd = "pandoc -f markdown -t rst -o README_{}.rst README.md".format(dir_name[2:])
        subprocess.call(cmd.split())
        cmd = "mv README_{}.rst {}".format(dir_name[2:], path_to_sphinx)
        subprocess.call(cmd.split())
        os.chdir(cwd_path)

#make index.rst in sphinx dir

with open(os.path.join(path_to_sphinx, "index.rst"), "w") as fw:
    text = """.. MAInstaller documentation master file, created by
   sphinx-quickstart on Sun May 10 14:29:22 2020.
   You can adapt this file completely to your liking, but it should at least
   contain the root `toctree` directive.
    
********************************
Application list
********************************
        
.. toctree::
   :maxdepth: 1
"""

    fw.write(text)
    fw.write("\n")
    for dir_name in dirs_apps:
        path_to_README = os.path.join(dir_name, "README.md")
        if os.path.isfile(path_to_README):
            dir_name = dir_name[2:]
            fw.write("   README_{}\n".format(dir_name))
