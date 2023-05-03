#!/bin/bash
rm -rf build/*
cd build
cmake .. -DCMAKE_BUILD_TYPE=Release -DCMAKE_CXX_COMPILER=`which icc` -DMPI_CXX_COMPILER=`which mpicc` -DWITH_MPI=ON -DWITH_OPENMP=ON -DCMAKE_CXX_FLAGS=-pg
make