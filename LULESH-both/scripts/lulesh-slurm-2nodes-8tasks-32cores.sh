#!/bin/bash
#SBATCH --job-name=LULESH2
#SBATCH --mail-type=FAIL
#SBATCH --mail-user=brianlien@ufl.edu
#SBATCH --account=eel6763
#SBATCH --qos=eel6763
#SBATCH --nodes=2
#SBATCH --ntasks=8
#SBATCH --cpus-per-task=4
#SBATCH --ntasks-per-node=4
#SBATCH --mem-per-cpu=700mb
#SBATCH -t 00:10:00
#SBATCH -o ./logs/lulesh-2nodes-8tasks-32cores.log
#SBATCH -e ./logs/lulesh-2nodes-8tasks-32cores.err
export OMP_NUM_THREADS=4
module load intel openmpi
export GMON_OUT_PREFIX=gmon.out-2nodes-8tasks-32cores-
srun --mpi=pmix_v3 ./build/lulesh2.0
