#!/bin/bash
#SBATCH --job-name=trimmomatic_equipo4
#SBATCH --output=/mnt/data/bioinfo-estadistica-2/RNAseq_2026/equipos/Equipo4/scripts/out_logs/trimmomatic_%A_%a.out
#SBATCH --error=/mnt/data/bioinfo-estadistica-2/RNAseq_2026/equipos/Equipo4/scripts/out_logs/trimmomatic_%A_%a.err
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=8
#SBATCH --mem=16G
#SBATCH --time=08:00:00
#SBATCH --array=0-5

set -euo pipefail
module load trimmomatic/0.33
BASE="/mnt/data/bioinfo-estadistica-2/RNAseq_2026/equipos/Equipo4"
ADAPTERS="${BASE}/data/adapters/TruSeq3-PE.fa"
OUT_DIR="${BASE}/data/processed"

SAMPLES=(
    "SRR33445252 control"
    "SRR33445253 control"
    "SRR33445254 control"
    "SRR33445260 tratamiento"
    "SRR33445261 tratamiento"
    "SRR33445262 tratamiento"
)

SAMPLE_INFO="${SAMPLES[$SLURM_ARRAY_TASK_ID]}"
SAMPLE=$(echo "${SAMPLE_INFO}" | awk '{print $1}')
GRUPO=$(echo "${SAMPLE_INFO}"  | awk '{print $2}')

INPUT_DIR="${BASE}/data/raw/${GRUPO}"
R1="${INPUT_DIR}/${SAMPLE}_1.fastq"
R2="${INPUT_DIR}/${SAMPLE}_2.fastq"

SAMPLE_OUT="${OUT_DIR}/${GRUPO}/${SAMPLE}"
mkdir -p "${SAMPLE_OUT}"

echo "============================="
echo " Muestra:  ${SAMPLE} | Grupo: ${GRUPO}"
echo " Fecha:    $(date)"
echo "============================="

for f in "${R1}" "${R2}" "${ADAPTERS}"; do
    if [[ ! -f "${f}" ]]; then
        echo "[ERROR] No encontrado: ${f}"
        exit 1
    fi
done

trimmomatic PE \
    -threads 8 \
    -phred33 \
    "${R1}" "${R2}" \
    "${SAMPLE_OUT}/${SAMPLE}_1_paired.fastq.gz" \
    "${SAMPLE_OUT}/${SAMPLE}_1_unpaired.fastq.gz" \
    "${SAMPLE_OUT}/${SAMPLE}_2_paired.fastq.gz" \
    "${SAMPLE_OUT}/${SAMPLE}_2_unpaired.fastq.gz" \
    ILLUMINACLIP:"${ADAPTERS}":2:30:10 \
    LEADING:5 \
    TRAILING:5 \
    SLIDINGWINDOW:4:20 \
    MINLEN:36

echo "[OK] Trimmomatic terminado: ${SAMPLE} - $(date)"

