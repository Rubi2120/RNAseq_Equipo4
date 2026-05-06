#!/bin/bash
#SBATCH --job-name=fastqc_array
#SBATCH --output=scripts/out_logs/fastqc_%A_%a.out
#SBATCH --error=scripts/out_logs/fastqc_%A_%a.err
#SBATCH --mem=4G
#SBATCH --cpus-per-task=2
#SBATCH --time=02:00:00
#SBATCH --array=0-10

module load fastqc/0.11.3

mkdir -p quality1/fastqc

file=$(sed -n "$((SLURM_ARRAY_TASK_ID+1))p" missing_fastq.txt)
base=$(basename "$file" .fastq)

echo "Procesando: $file"

fastqc "$file" -o quality1/fastqc



