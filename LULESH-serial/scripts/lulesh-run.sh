#!/bin/bash

rm ./gmon.out-*
rm ./gprof-*
rm ./logs/*

SLURMFILE="./scripts/lulesh-slurm-serial.sh"
sbatch $SLURMFILE
