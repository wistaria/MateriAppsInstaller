QUANTUM ESPRESSO
================

SUMMARY
-------

Open-source program for first-principles calculation based on
pseudo-potential and plane-wave basis. This package performs
electronic-state calculation with high accuracy based on density
functional theory. In addition to basic-set programs, many core-packages
and plugins are included. This package can be utilized for academic
research and industrial development, and also supports parallel
computing.

LICENSE
-------

GNU GPL v2

OFFICIAL PAGE
-------------

http://www.quantum-espresso.org/

MateriApps URL
--------------

https://ma.issp.u-tokyo.ac.jp/en/app/740

GPU build (mode ``gpu``)
------------------------

``sh install.sh gpu`` builds the NVIDIA GPU (CUDA / OpenACC) version with the
NVHPC compilers (``nvfortran`` / ``nvc``) and a CUDA-aware MPI — e.g. after
``module load nvhpc openmpi_nvhpc`` on an NVHPC/CUDA machine. ``nvfortran``
targets the GPU of the build node by default; set ``MA_EXTRA_FLAGS="-gpu=ccXX"``
(e.g. ``cc80`` for A100) to target a specific compute capability when building
off the target node. This mode needs an NVIDIA GPU + CUDA toolchain and is
therefore not covered by CI. Verified on ISSP kugui (A100): ``pw.x`` reports
"GPU acceleration is ACTIVE".
