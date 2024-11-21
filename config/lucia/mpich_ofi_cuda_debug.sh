#!/bin/bash
#SBATCH --job-name=dbs
#SBATCH --partition=gpu
#SBATCH --nodes=1
#SBATCH --tasks-per-node=8
#SBATCH --gpus-per-node=1
#SBATCH --mem=128G
#SBATCH --account=examples
#SBATCH --time=2:00:00

module purge
module load EasyBuild/2023a
module load CUDA/12.2.0
module load GCC/12.3.0
module load GDRCopy/2.3.1-GCCcore-12.3.0.lua
module load CMake
module list

export CFLAGS="-fsanitize=address ${CFLAGS}"
export CXXFLAGS="-fsanitize=address ${CXXFLAGS}"
export LDFLAGS="-fsanitize=address ${LDFLAGS}"

CLUSTER=lucia/mpich_ofi_cuda_debug make info
CLUSTER=lucia/mpich_ofi_cuda_debug make install
