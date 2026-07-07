How to use ITensor Library from your program
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

1. Setup environment variables using ``itensorvars.sh``

   .. code:: sh

      $ source ${MA_ROOT}/itensor/itensorvars.sh

2. Create ``CMakeLists.txt``: e.g.

   ::

      cmake_minimum_required(VERSION 3.14)
      project(myproject CXX)
      find_package(ITensor REQUIRED)
      add_executable(main main.cc)
      target_link_libraries(main ITensor::ITensor)

3. CMake and compile

   .. code:: sh

      $ cmake -B build
      $ cmake --build build
