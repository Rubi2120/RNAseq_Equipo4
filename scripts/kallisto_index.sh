#!/bin/bash
#SBATCH --job-name=kallisto_index
#SBATCH --nodes=1
#SBATCH --ntasks=4
#SBATCH --time=01:00:00
#SBATCH --mem=8G
#SBATCH --output=kallisto_index.out
#SBATCH --error=kallisto_index.err

module load kallisto

cd /mnt/data/bioinfo-estadistica-2/RNAseq_2026/equipos/Equipo4/data/reference

kallisto index -i mouse_M24.idx gencode.vM24.transcripts.fa.gz
