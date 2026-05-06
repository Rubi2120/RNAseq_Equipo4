#!/bin/bash
#SBATCH --job-name=fastqc_missing
#SBATCH --output=scripts/out_logs/fastqc_missing_%j.out
#SBATCH --error=scripts/out_logs/fastqc_missing_%j.err
#SBATCH --mem=4G
#SBATCH --cpus-per-task=2
#SBATCH --time=02:00:00

module load fastqc/0.11.3

OUTDIR=quality1/fastqc

for file in data/raw/*/*.fastq; do
    base=$(basename $file .fastq)

    if [ ! -f quality1/fastqc/${base}_fastqc.html ]; then
        echo "Procesando $file"
        fastqc "$file" -o "$OUTDIR"
    fi
done
