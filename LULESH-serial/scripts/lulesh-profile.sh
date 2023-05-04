#!/bin/bash

rm -rf out/*
mv gmon.* ./out
cd out
BINARY=../build/lulesh2.0
GMONOUTS="gmon.out-serial*"
GMONDIR="serial"
GPROFFILE="gprof-serial.txt"
DOTFILE="gprof-serial.png"
gprof $BINARY $GMONOUTS >> $GPROFFILE
gprof $BINARY $GMONOUTS | ../../gprof2dot.py --strip --wrap | dot -Tpng -o $DOTFILE
mkdir $GMONDIR
mv $GMONOUTS ./$GMONDIR
