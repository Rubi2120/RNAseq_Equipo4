# Análisis de Expresión Diferencial en Hígado de Ratón: Wild-type vs Dp16 (Modelo de Síndrome de Down)

**Materia:** Bioinformática y Estadística II  
**Semestre:** Mayo 2026  
**Equipo:** 4

---

## Integrantes

| Nombre | Usuario | Correo |
|--------|---------|--------|
| Rubí Martínez Chavarría | rmartinez | rubimarch201@gmail.com |
| Leonardo Ivan Anaya González | lanaya | leoianayaglz@gmail.com |

---

## Resumen

Se realizó un análisis de RNA-seq de tejido hepático de ratón adulto comparando la condición wild-type (WT) contra el modelo Dp(16)1Yey (Dp16) de Síndrome de Down. Los datos provienen del bioproyecto PRJNA1259260 (GEO: GSE296420), generados con Illumina NovaSeq 6000 en modalidad paired-end (150 bp, selección polyA, ~25–35 M lecturas por muestra). Se seleccionaron 6 muestras (3 WT y 3 Dp16) con base en profundidad de secuenciación y porcentaje de duplicación. El pipeline incluyó control de calidad con FastQC y MultiQC, limpieza de adaptadores con Trimmomatic, pseudoalineamiento con Kallisto, alineamiento con STAR y análisis de expresión diferencial con DESeq2, seguido de enriquecimiento funcional de términos GO con gprofiler2. Se identificaron 400 DEGs (Kallisto) y 363 (STAR) con padj < 0.05, con activación masiva de metabolismo lipídico y represión de cascada del complemento en hígado Dp16, consistentes con Dunn et al. (2026).

---

## 🔗 Reporte renderizado

- 📄 **[Ver reporte final completo (Entregables 2, 3 y 4)](Entregables_Completo_final.html)**
- 📄 [Ver reporte Entregable 4 — DEG + Análisis Funcional GO](https://Rubi2120.github.io/RNAseq_Equipo4/entregable4_fin.html)
- 📄 [Ver reporte Entregable 3 — FastQC, Trimmomatic, STAR, Kallisto](https://Rubi2120.github.io/RNAseq_Equipo4/Entregable3_corregido_final.html)

---

## Descripción de los datos

| Campo | Información |
|-------|-------------|
| Bioproject | PRJNA1259260 |
| GEO Accession | GSE296420 |
| Especie | *Mus musculus* |
| Tipo de bibliotecas | Paired-end (PolyA RNA-seq) |
| Método de selección | PolyA (mRNA) |
| Número de transcriptomas | 12 (6 WT, 6 Dp16) |
| Réplicas biológicas | 6 por condición |
| Secuenciador | Illumina NovaSeq 6000 |
| Profundidad | ~25–35 M lecturas por muestra |
| Tamaño de lecturas | 150 bp |
| Tejido | Hígado de ratón adulto (19–26 semanas) |
| Artículo de referencia | Dunn et al., 2026. Cell Reports. DOI: 10.1016/j.celrep.2025.116835 |

**Muestras seleccionadas:**

| SRR | Condición | Réplica |
|-----|-----------|---------|
| SRR33445253 | Control (WT) | WT_1 |
| SRR33445254 | Control (WT) | WT_2 |
| SRR33445257 | Control (WT) | WT_3 |
| SRR33445260 | Tratamiento (Dp16) | Dp16_1 |
| SRR33445261 | Tratamiento (Dp16) | Dp16_2 |
| SRR33445262 | Tratamiento (Dp16) | Dp16_3 |

---

## Estructura del repositorio

```
RNAseq_Equipo4/
├── DEG_results/
│   ├── DESeq2_STAR_results.csv
│   └── DESeq2_kallisto_results.csv
├── diagrama_de_flujo/
├── figures/
│   ├── fastqc_sequence_counts_plot.png
│   ├── fastqc_adapter_content_plot.png
│   ├── fastqc_per_base_sequence_quality_plot_trimmed.png
│   ├── fastqc_per_base_sequence_quality_plot.png
│   ├── fastqc_per_sequence_gc_content_plot.png
│   ├── fastqc_per_sequence_quality_scores_plot.png
│   ├── fastqc_sequence_duplication_levels_plot.png
│   ├── PCA_rlog_STAR.png
│   ├── PCA_rlog_kallisto.png
│   ├── VolcanoPlot_STAR.png
│   ├── VolcanoPlot.png
│   ├── Heatmap_STAR.pdf
│   ├── Heatmap.pdf
│   ├── pipeline_rnaseq.png
│   ├── string_down_image.png
│   └── string_normal_image.png
├── infografia/
├── quality1/
│   └── multiqc_report.html            # MultiQC datos crudos
├── quality2/
│   └── multiqc_report.html            # MultiQC post-Trimmomatic
├── results_final/
│   ├── STAR/                          # ReadsPerGene.out.tab por muestra
│   ├── kallisto/                      # abundance.h5 y abundance.tsv por muestra
│   ├── DESeq2_STAR_results.csv
│   ├── DESeq2_kallisto_results.csv
│   ├── DESeq2_STAR_significant.csv
│   ├── DESeq2_kallisto_significant.csv
│   ├── GOterms_gprofiler2_results.csv
│   └── tx2gene_kallisto.csv
├── scripts/
│   ├── out_logs/                      # SLURM outlogs de todos los pasos
│   ├── 01_download_adapters.sh
│   ├── 02_trimmomatic.sh
│   ├── 03_kallisto.sh
│   ├── 04_STAR_index.sh
│   ├── 05_STAR_align.sh
│   └── ...
├── Entregables_Completo.Rmd           # Reporte final unificado
├── Entregables_Completo_final.html          # Reporte final renderizado
├── metadata.csv
└── README.md
```

Los datos crudos (.fastq.gz), el índice STAR y el genoma de referencia no están en el repositorio por su tamaño. Se encuentran en el cluster `ken.lavis.unam.mx` en la ruta `/mnt/data/bioinfo-estadistica-2/RNAseq_2026/equipos/Equipo4/`

---

## Pipeline y scripts

### Paso 1 — Control de calidad de datos crudos
- **Programa:** FastQC + MultiQC
- **Script:** `scripts/fastqc_array.sh`
- **Output:** `quality1/multiqc_report.html`
- **Outlogs:** `scripts/out_logs/download.out`, `download.err`

### Paso 2 — Limpieza de adaptadores
- **Programa:** Trimmomatic v0.39
- **Script:** `scripts/trimmomatic_final.sh`
- **Outlogs:** `scripts/out_logs/trimm_final_1611.out`, `trimm_final_1611.err`
- **Parámetros:** `ILLUMINACLIP:TruSeq3-PE.fa:2:30:10 LEADING:5 TRAILING:5 SLIDINGWINDOW:4:20 MINLEN:36`

### Paso 3 — Control de calidad post-trimming
- **Programa:** FastQC + MultiQC
- **Output:** `quality2/multiqc_report.html`

### Paso 4 — Pseudoalineamiento con Kallisto
- **Programa:** Kallisto
- **Script:** `scripts/03_kallisto.sh`
- **Output:** `results_final/kallisto/SRR*/abundance.h5`
- **Outlogs:** `scripts/out_logs/kallisto_1511_*.out/err`

### Paso 5 — Alineamiento con STAR
- **Programa:** STAR 2.7.9a
- **Scripts:** `scripts/04_STAR_index.sh`, `scripts/05_STAR_align.sh`
- **Output:** `results_final/STAR/SRR*/*.ReadsPerGene.out.tab`
- **Outlogs:** `scripts/out_logs/STAR_align_1520_*.out/err`

### Paso 6 — Expresión diferencial (DESeq2)
- **Programa:** DESeq2 (R) + tximport + apeglm
- **Script:** `scripts/Entregable4_final.Rmd`
- **Output:** `DEG_results/`, `results_final/DESeq2_*_significant.csv`

### Paso 7 — Análisis funcional (GO)
- **Programa:** gprofiler2 (R)
- **Output:** `results_final/GOterms_gprofiler2_results.csv`

---

## Resultados principales

| Métrica | Kallisto | STAR |
|---------|----------|------|
| Genes analizados | ~17,000 | ~16,500 |
| DEGs (padj < 0.05) | 400 | 363 |
| Up-regulated | ~43% | ~43% |
| Down-regulated | ~57% | ~57% |
| Genes compartidos | 264 (~66%) | 264 (~73%) |

- **Up-regulated en Dp16:** metabolismo de lípidos, ácidos grasos y ácidos biliares (FDR hasta 1.54e-23)
- **Down-regulated en Dp16:** cascada del complemento e inmunidad humoral (FDR hasta 5.80e-11)

---

## Referencias

1. Dunn, L.N. et al., 2026. Altered hepatic metabolism in Down syndrome. *Cell Reports*. DOI: 10.1016/j.celrep.2025.116835
2. Chen et al., 2026. Gene dosage imbalance disrupts systemic metabolism in the Dp16 Down syndrome mouse model. *eLife*. DOI: 10.7554/eLife.110476
3. Love, M.I., Huber, W., & Anders, S., 2014. Moderated estimation of fold change and dispersion for RNA-seq data with DESeq2. *Genome Biology*, 15, 550. DOI: 10.1186/s13059-014-0550-8
4. Dobin, A. et al., 2013. STAR: ultrafast universal RNA-seq aligner. *Bioinformatics*, 29(1), 15–21. DOI: 10.1093/bioinformatics/bts635

---

*Análisis realizado en el cluster ken.lavis.unam.mx*  
*Ruta del proyecto: `/mnt/data/bioinfo-estadistica-2/RNAseq_2026/equipos/Equipo4/`*
