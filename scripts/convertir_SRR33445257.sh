#!/bin/bash
#SBATCH --job-name=convert_257
#SBATCH --output=logs/slurm/convert_257_%j.out
#SBATCH --error=logs/slurm/convert_257_%j.err
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=4
#SBATCH --mem=8G
#SBATCH --mail-type=END
#SBATCH --mail-user=ecossnav@gmail.com

module load sra-toolkit

fastq-dump --split-files \
    data/raw/SRR33445257/SRR33445257.sra \
    -O data/raw/tratamiento/

