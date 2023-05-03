#!/bin/bash
NTHREADS_TASK=(1 4 16 32)
NTASKS=(1 8 27)
NNODES=(1 2 4)
CORE_MAX=32
NODE_MAX=32

rm ./gmon.out-*
rm ./gprof-*
for NTH in $(seq 0 0)
do
    for NT in $(seq 0 2)
    do
        for NN in $(seq 0 2)
        do
            NTHREADS=$((${NTASKS[$NT]} * ${NTHREADS_TASK[$NTH]}))
            NTASKS_NODE=$(( ${NTASKS[$NT]} / ${NNODES[$NN]} ))
            if [[ $(( ${NTASKS[$NT]} % ${NNODES[$NN]} )) -gt 0 ]]; then
                NTASKS_NODE=$(( $NTASKS_NODE + 1 ))
            fi
            if [[ $NTHREADS -le $CORE_MAX && $NTASKS_NODE -le $NODE_MAX && ${NTASKS[$NT]} -ge ${NNODES[$NN]} ]]; then
            
                SLURMFILE="./scripts/lulesh-slurm-${NNODES[$NN]}nodes-${NTASKS[$NT]}tasks-${NTHREADS}cores.sh"
                sbatch $SLURMFILE
            fi
        done
    done
done
