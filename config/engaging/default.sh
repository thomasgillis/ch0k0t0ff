#!/bin/bash
#SBATCH --partition=sched_mit_wvanrees
#SBATCH --time=6:00:00
#SBATCH --ntasks=8

#-------------------------------------------------------------------------------
module purge
module load gcc/11.2.0
zlib
#-------------------------------------------------------------------------------
module list
#-------------------------------------------------------------------------------
CLUSTER=engaging/default make info
CLUSTER=engaging/default make install
#-------------------------------------------------------------------------------
