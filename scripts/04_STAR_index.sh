#!/bin/bash
#SBATCH --job-name=STAR_index_equipo4
#SBATCH --output=/mnt/data/bioinfo-estadistica-2/RNAseq_2026/equipos/Equipo4/scripts/out_logs/STAR_index.out
#SBATCH --error=/mnt/data/bioinfo-estadistica-2/RNAseq_2026/equipos/Equipo4/scripts/out_logs/STAR_index.err
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=8
#SBATCH --mem=40G
#SBATCH --time=08:00:00

module load star/2.7.9a

set -euo pipefail

BASE="/mnt/data/bioinfo-estadistica-2/RNAseq_2026/equipos/Equipo4"
GENOME="${BASE}/data/reference/GRCm38.primary_assembly.genome.fa"
GTF="${BASE}/data/reference/gencode.vM24.annotation.gtf"
INDEX_DIR="${BASE}/data/STAR_index"

echo "============================="
echo " Creando índice STAR"
echo " Fecha: $(date)"
echo "============================="

STAR --runThreadN 8 \
     --runMode genomeGenerate \
     --genomeDir "${INDEX_DIR}" \
     --genomeFastaFiles "${GENOME}" \
     --sjdbGTFfile "${GTF}" \
     --sjdbOverhang 149

echo "[OK] Índice STAR terminado: $(date)"
