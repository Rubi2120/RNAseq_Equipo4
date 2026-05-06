#!/bin/bash
#SBATCH --job-name=trim
#SBATCH --array=0-5
#SBATCH --cpus-per-task=4
#SBATCH --time=02:00:00
#SBATCH --mem=8G
#SBATCH -o trim_%A_%a.out

module load trimmomatic

mkdir -p my_results/trimmed

SAMPLES=(SRR33445252 SRR33445253 SRR33445254 SRR33445257 SRR33445260 SRR33445261)

SAMPLE=${SAMPLES[$SLURM_ARRAY_TASK_ID]}

trimmomatic PE \
data/raw/control/${SAMPLE}_1.fastq \
data/raw/control/${SAMPLE}_2.fastq \
my_results/trimmed/${SAMPLE}_1_trim.fastq \
my_results/trimmed/${SAMPLE}_1_unpaired.fastq \
my_results/trimmed/${SAMPLE}_2_trim.fastq \
my_results/trimmed/${SAMPLE}_2_unpaired.fastq \
ILLUMINACLIP:data/adapters/TruSeq3-PE.fa:2:30:10 \
SLIDINGWINDOW:4:20 MINLEN:36

