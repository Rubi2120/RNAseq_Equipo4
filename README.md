
> Los datos crudos (.fastq.gz), índice STAR y genoma de referencia están en el cluster `ken.lavis.unam.mx` en `/mnt/data/bioinfo-estadistica-2/RNAseq_2026/equipos/Equipo4/`

---

## Pipeline y scripts

### Paso 1 — Control de calidad de datos crudos
| | |
|---|---|
| **Programa** | FastQC v0.11.x + MultiQC |
| **Script** | `scripts/fastqc_array.sh` |
| **Output** | `quality1/multiqc_crudos_real.html` |
| **Outlogs** | `scripts/out_logs/download.out`, `download.err` |

### Paso 2 — Limpieza de adaptadores
| | |
|---|---|
| **Programa** | Trimmomatic v0.39 |
| **Script** | `scripts/trimmomatic_final.sh` |
| **Output** | `data/processed/*_paired.fastq.gz` (cluster) |
| **Outlogs** | `scripts/out_logs/trimm_final_1611.out/err` |

Parámetros: `ILLUMINACLIP:TruSeq3-PE.fa:2:30:10 LEADING:3 TRAILING:3 SLIDINGWINDOW:4:15 MINLEN:36`

### Paso 3 — Control de calidad post-trimming
| | |
|---|---|
| **Output** | `quality2/multiqc_trimmed_final.html` |

### Paso 4 — Pseudoalineamiento Kallisto
| | |
|---|---|
| **Script** | `scripts/03_kallisto.sh` |
| **Output** | `results_final/kallisto/SRR*/abundance.tsv` y `abundance.h5` |
| **Outlogs** | `scripts/out_logs/kallisto_1511_*.out/err` |

### Paso 5 — Alineamiento STAR
| | |
|---|---|
| **Scripts** | `scripts/04_STAR_index.sh`, `scripts/05_STAR_align.sh` |
| **Output** | `results_final/STAR/SRR*/*.ReadsPerGene.out.tab` |
| **Outlogs** | `scripts/out_logs/STAR_align_1520_*.out/err` |

### Paso 6 — Expresión diferencial (DESeq2)
| | |
|---|---|
| **Script** | `scripts/Entregable4_final.Rmd` |
| **Output** | `DEG_results/`, `results_final/GOterms_gprofiler2_results.csv` |

---

## Resultados principales

- **DEGs identificados:** 400 (Kallisto) y 363 (STAR) con padj < 0.05
- **Genes compartidos entre pipelines:** 264 (~66–73% overlap)
- **Up-regulated en Dp16:** metabolismo de lípidos, ácidos grasos y ácidos biliares (FDR hasta 1.54e-23)
- **Down-regulated en Dp16:** cascada del complemento e inmunidad humoral (FDR hasta 5.80e-11)

---

## Referencias

1. Dunn, A. et al., 2026. Altered hepatic metabolism in Down syndrome. *Cell Reports*. DOI: [10.1016/j.celrep.2025.116835](https://doi.org/10.1016/j.celrep.2025.116835)

2. Love, M.I., Huber, W., & Anders, S., 2014. Moderated estimation of fold change and dispersion for RNA-seq data with DESeq2. *Genome Biology*, 15, 550. DOI: [10.1186/s13059-014-0550-8](https://doi.org/10.1186/s13059-014-0550-8)

3. Tian, Y. et al., 2023. Gene dosage imbalance disrupts systemic metabolism in the Dp16 Down syndrome mouse model. *eLife*. DOI: [10.64898/2026.01.13.699318](https://doi.org/10.64898/2026.01.13.699318)

4. Bray, N.L., Pimentel, H., Melsted, P., & Pachter, L., 2016. Near-optimal probabilistic RNA-seq quantification. *Nature Biotechnology*, 34, 525–527. DOI: [10.1038/nbt.3519](https://doi.org/10.1038/nbt.3519)

---

*Análisis realizado en el cluster `ken.lavis.unam.mx`*  
*Ruta del proyecto: `/mnt/data/bioinfo-estadistica-2/RNAseq_2026/equipos/Equipo4/`*
