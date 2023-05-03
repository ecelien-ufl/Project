#!/bin/bash
#SBATCH --job-name=LULESH2
#SBATCH --mail-type=FAIL
#SBATCH --mail-user=brianlien@ufl.edu
#SBATCH --account=eel6763
#SBATCH --qos=eel6763
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=1
#SBATCH --ntasks-per-node=1
#SBATCH --mem-per-cpu=700mb
#SBATCH -t 00:10:00
#SBATCH -o ./logs/lulesh-serial.log
#SBATCH -e ./logs/lulesh-serial.err
export OMP_NUM_THREADS=1
module load intel openmpi
export GMON_OUT_PREFIX=gmon.out-serial
./build/lulesh2.0 -g
