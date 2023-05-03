#!/bin/bash
NTHREADS_TASK=(1 4 16 32)
NTASKS=(1 8 27)
NNODES=(1 2 4)
CORE_MAX=32
NODE_MAX=32

rm ./scripts/lulesh-slurm-*.sh
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
                OUTFILE="./logs/lulesh-${NNODES[$NN]}nodes-${NTASKS[$NT]}tasks-${NTHREADS}cores.log"
                ERRFILE="./logs/lulesh-${NNODES[$NN]}nodes-${NTASKS[$NT]}tasks-${NTHREADS}cores.err"
                GMONPREFIX="gmon.out-${NNODES[$NN]}nodes-${NTASKS[$NT]}tasks-${NTHREADS}cores-"
                BINARY=./build/lulesh2.0
                echo "#!/bin/bash" >> $SLURMFILE
                echo "#SBATCH --job-name=LULESH2" >> $SLURMFILE
                echo "#SBATCH --mail-type=FAIL" >> $SLURMFILE
                echo "#SBATCH --mail-user=brianlien@ufl.edu" >> $SLURMFILE
                echo "#SBATCH --account=eel6763" >> $SLURMFILE
                echo "#SBATCH --qos=eel6763" >> $SLURMFILE
                echo "#SBATCH --nodes=${NNODES[$NN]}" >> $SLURMFILE
                echo "#SBATCH --ntasks=${NTASKS[$NT]}" >> $SLURMFILE
                echo "#SBATCH --cpus-per-task=${NTHREADS_TASK[$NTH]}" >> $SLURMFILE
                echo "#SBATCH --ntasks-per-node=${NTASKS_NODE}" >> $SLURMFILE
                echo "#SBATCH --mem-per-cpu=700mb" >> $SLURMFILE
                echo "#SBATCH -t 00:10:00" >> $SLURMFILE
                echo "#SBATCH -o $OUTFILE" >> $SLURMFILE
                echo "#SBATCH -e $ERRFILE" >> $SLURMFILE
                echo "export OMP_NUM_THREADS=${NTHREADS_TASK[$NTH]}" >> $SLURMFILE
                echo "module load intel openmpi" >> $SLURMFILE
                echo "export GMON_OUT_PREFIX=$GMONPREFIX" >> $SLURMFILE
                echo "srun --mpi=pmix_v3 $BINARY" >> $SLURMFILE
            fi
        done
    done
done
