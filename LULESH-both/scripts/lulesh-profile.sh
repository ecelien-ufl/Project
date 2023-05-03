#!/bin/bash
NTHREADS_TASK=(1 4 16 32)
NTASKS=(1 8 27)
NNODES=(1 2 4)
CORE_MAX=32
NODE_MAX=32

rm -rf out/*
mv gmon.* ./out
cd out
for NTH in $(seq 0 3)
do
    for NT in $(seq 0 2)
    do
        for NN in $(seq 0 2)
        do
            BINARY=../build/lulesh2.0
            NTHREADS=$((${NTASKS[$NT]} * ${NTHREADS_TASK[$NTH]}))
            NTASKS_NODE=$(( ${NTASKS[$NT]} / ${NNODES[$NN]} ))
            if [[ $(( ${NTASKS[$NT]} % ${NNODES[$NN]} )) -gt 0 ]]; then
                NTASKS_NODE=$(( $NTASKS_NODE + 1 ))
            fi
            if [[ $NTHREADS -le $CORE_MAX && $NTASKS_NODE -le $NODE_MAX && ${NTASKS[$NT]} -ge ${NNODES[$NN]} ]]; then
                GMONOUTS="gmon.out-${NNODES[$NN]}nodes-${NTASKS[$NT]}tasks-${NTHREADS}cores-*"
                GMONDIR="${NNODES[$NN]}nodes-${NTASKS[$NT]}tasks-${NTHREADS}cores"
                GPROFFILE="gprof-${NNODES[$NN]}nodes-${NTASKS[$NT]}tasks-${NTHREADS}cores.txt"
                gprof $BINARY $GMONOUTS >> $GPROFFILE
                mkdir $GMONDIR
                mv $GMONOUTS ./$GMONDIR
            fi
        done
    done
done
