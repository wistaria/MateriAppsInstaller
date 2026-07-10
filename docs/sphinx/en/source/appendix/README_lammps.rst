LAMMPS
======

SUMMARY
-------

A general-purpose open-source application for classical molecular
dynamics simulation, distributed under the GPL license. This package can
perform molecular dynamics calculation of various systems such as soft
matters, solids, and mesoscopic systems. It can be used as a simulator
of classical dynamics of realistic atoms as well as general model
particles. It supports parallel computing through spatial divisions. Its
codes are designed so that their modification and extension are easy.

LICENSE
-------

GPLv2

OFFICIAL PAGE
-------------

https://lammps.sandia.gov

MateriApps URL
--------------

https://ma.issp.u-tokyo.ac.jp/en/app/613

GPU build (mode ``gpu``)
------------------------

``sh install.sh gpu`` builds the NVIDIA GPU (KOKKOS / CUDA) version. Set the
target GPU architecture first via the ``KOKKOS_ARCH`` environment variable
(required, no default): e.g. ``export KOKKOS_ARCH=AMPERE80`` for A100. Common
values are ``AMPERE80`` (A100), ``VOLTA70`` (V100), ``HOPPER90`` (H100),
``TURING75`` (T4), ``ADA89`` (RTX 40), ``PASCAL60`` (P100). A wrong
architecture still builds but fails at run time on the GPU. Requires the CUDA
toolkit (``nvcc``) and a CUDA-aware MPI on ``PATH``. This mode needs an NVIDIA
GPU and is not covered by CI. Verified on ISSP kugui (A100).
