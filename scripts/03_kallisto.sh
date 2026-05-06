#!/bin/bash
#SBATCH --job-name=kallisto_equipo4
#SBATCH --output=/mnt/data/bioinfo-estadistica-2/RNAseq_2026/equipos/Equipo4/scripts/out_logs/kallisto_%A_%a.out
#SBATCH --error=/mnt/data/bioinfo-estadistica-2/RNAseq_2026/equipos/Equipo4/scripts/out_logs/kallisto_%A_%a.err
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=8
#SBATCH --mem=16G
#SBATCH --time=08:00:00
#SBATCH --array=0-5

module load kallisto

set -euo pipefail

BASE="/mnt/data/bioinfo-estadistica-2/RNAseq_2026/equipos/Equipo4"
IDX="${BASE}/data/reference/mouse_M24.idx"
OUT_DIR="${BASE}/results/kallisto"

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

FILE_1="${BASE}/data/processed/${GRUPO}/${SAMPLE}/${SAMPLE}_1_paired.fastq.gz"
FILE_2="${BASE}/data/processed/${GRUPO}/${SAMPLE}/${SAMPLE}_2_paired.fastq.gz"

mkdir -p "${OUT_DIR}/${SAMPLE}"

echo "============================="
echo " Muestra:  ${SAMPLE} | Grupo: ${GRUPO}"
echo " Fecha:    $(date)"
echo "============================="

for f in "${FILE_1}" "${FILE_2}" "${IDX}"; do
    if [[ ! -f "${f}" ]]; then
        echo "[ERROR] No encontrado: ${f}"
        exit 1
    fi
done

kallisto quant \
    --index "${IDX}" \
    --output-dir "${OUT_DIR}/${SAMPLE}" \
    --threads 8 \
    "${FILE_1}" "${FILE_2}"

echo "[OK] Kallisto terminado: ${SAMPLE} - $(date)"

