#!/bin/bash
#SBATCH --job-name=STAR_align_equipo4
#SBATCH --output=/mnt/data/bioinfo-estadistica-2/RNAseq_2026/equipos/Equipo4/scripts/out_logs/STAR_align_%A_%a.out
#SBATCH --error=/mnt/data/bioinfo-estadistica-2/RNAseq_2026/equipos/Equipo4/scripts/out_logs/STAR_align_%A_%a.err
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=8
#SBATCH --mem=40G
#SBATCH --time=08:00:00
#SBATCH --array=0-5

module load star/2.7.9a

set -euo pipefail

BASE="/mnt/data/bioinfo-estadistica-2/RNAseq_2026/equipos/Equipo4"
INDEX_DIR="${BASE}/data/STAR_index"
OUT_DIR="${BASE}/results/STAR"

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

for f in "${FILE_1}" "${FILE_2}" "${INDEX_DIR}"; do
    if [[ ! -f "${f}" && ! -d "${f}" ]]; then
        echo "[ERROR] No encontrado: ${f}"
        exit 1
    fi
done

STAR --runThreadN 8 \
     --genomeDir "${INDEX_DIR}" \
     --readFilesIn "${FILE_1}" "${FILE_2}" \
     --outSAMtype BAM SortedByCoordinate \
     --quantMode GeneCounts \
     --readFilesCommand zcat \
     --outFileNamePrefix "${OUT_DIR}/${SAMPLE}/${SAMPLE}."

echo "[OK] STAR terminado: ${SAMPLE} - $(date)"
