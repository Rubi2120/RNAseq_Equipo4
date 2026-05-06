#!/bin/bash
set -euo pipefail

BASE="/mnt/data/bioinfo-estadistica-2/RNAseq_2026/equipos/Equipo4"
ADAPTERS_DIR="${BASE}/data/adapters"

echo "Creando carpeta de adaptadores..."
mkdir -p "${ADAPTERS_DIR}"

echo "Descargando TruSeq3-PE.fa..."
wget -q --show-progress \
    "https://raw.githubusercontent.com/usadellab/Trimmomatic/main/adapters/TruSeq3-PE.fa" \
    -O "${ADAPTERS_DIR}/TruSeq3-PE.fa"

if [[ -s "${ADAPTERS_DIR}/TruSeq3-PE.fa" ]]; then
    echo "[OK] Descarga exitosa. Contenido:"
    cat "${ADAPTERS_DIR}/TruSeq3-PE.fa"
else
    echo "[ERROR] Descarga fallida."
    exit 1
fi
