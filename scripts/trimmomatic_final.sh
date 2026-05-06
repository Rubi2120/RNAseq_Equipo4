#!/bin/bash
#SBATCH --job-name=trimm_final
#SBATCH --output=logs/slurm/trimm_final_%j.out
#SBATCH --error=logs/slurm/trimm_final_%j.err
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=8
#SBATCH --mem=16G
#SBATCH --mail-type=END
#SBATCH --mail-user=ecossnav@gmail.com

module load trimmomatic/0.33

mkdir -p data/trimmed_final

ADAPTERS=data/adapters/TruSeq3-PE.fa
OUT=data/trimmed_final

for i in data/raw/control/*_1.fastq; do
    base=$(basename $i _1.fastq)
    echo "Procesando: $base"
    trimmomatic PE -threads 8 -phred33 \
        data/raw/control/${base}_1.fastq \
        data/raw/control/${base}_2.fastq \
        ${OUT}/${base}_1_paired.fastq.gz \
        ${OUT}/${base}_1_unpaired.fastq.gz \
        ${OUT}/${base}_2_paired.fastq.gz \
        ${OUT}/${base}_2_unpaired.fastq.gz \
        ILLUMINACLIP:${ADAPTERS}:2:30:10 \
        LEADING:3 TRAILING:3 \
        SLIDINGWINDOW:4:20 MINLEN:36
done

for i in data/raw/tratamiento/*_1.fastq; do
    base=$(basename $i _1.fastq)
    echo "Procesando: $base"
    trimmomatic PE -threads 8 -phred33 \
        data/raw/tratamiento/${base}_1.fastq \
        data/raw/tratamiento/${base}_2.fastq \
        ${OUT}/${base}_1_paired.fastq.gz \
        ${OUT}/${base}_1_unpaired.fastq.gz \
        ${OUT}/${base}_2_paired.fastq.gz \
        ${OUT}/${base}_2_unpaired.fastq.gz \
        ILLUMINACLIP:${ADAPTERS}:2:30:10 \
        LEADING:3 TRAILING:3 \
        SLIDINGWINDOW:4:20 MINLEN:36
done

