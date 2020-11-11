cmake_minimum_required(VERSION 3.1 FATAL_ERROR)
project(test CXX)
find_package(Boost COMPONENTS chrono date_time filesystem iostreams program_options regex system serialization thread timer unit_test_framework REQUIRED)
