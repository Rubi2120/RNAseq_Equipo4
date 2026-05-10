# Analisis de expresion diferencial en higado de raton: Wild-type vs Dp16 (modelo de Sindrome de Down)

**Materia:** Bioinformatica y Estadistica II  
**Semestre:** Mayo 2026  
**Equipo:** 4

## Integrantes

- Rubi Martinez Chavarria (rmartinez) — rubimarch201@gmail.com  
- Leonardo Ivan Anaya Gonzalez (lanaya) — leoianayaglz@gmail.com  

---

## Resumen

Se realizo un analisis de RNA-seq de tejido hepatico de raton adulto comparando la condicion wild-type (WT) contra el modelo Dp(16)1Yey (Dp16) de Sindrome de Down. Los datos provienen del bioproyecto PRJNA1259260 (GEO: GSE296420), generados con Illumina NovaSeq 6000 en modalidad paired-end (150 bp, seleccion polyA, ~25–35 M lecturas por muestra). Se seleccionaron 6 muestras (3 WT y 3 Dp16) con base en profundidad de secuenciacion y porcentaje de duplicacion. El pipeline incluyó control de calidad con FastQC y MultiQC, limpieza de adaptadores con Trimmomatic, pseudoalineamiento con Kallisto, alineamiento con STAR y analisis de expresion diferencial con DESeq2. Los resultados muestran genes diferencialmente expresados asociados a metabolismo hepatico, consistentes con los reportados en el articulo de referencia (Dunn et al., 2026).

---

## Reporte renderizado

[Ver reporte completo en GitHub Pages](https://rubi2120.github.io/RNAseq_Equipo4/Entregable3_final.html)

---

## Descripcion de los datos

| Campo | Informacion |
|---|---|
| Bioproject | PRJNA1259260 |
| GEO Accession | GSE296420 |
| Especie | Mus musculus |
| Tipo de bibliotecas | Paired-end (PolyA RNA-seq) |
| Metodo de seleccion | PolyA (mRNA) |
| Numero de transcriptomas | 12 (6 WT, 6 Dp16) |
| Replicas biologicas | 6 por condicion |
| Secuenciador | Illumina NovaSeq 6000 |
| Profundidad | ~25–35 M lecturas por muestra |
| Tamano de lecturas | 150 bp |
| Tejido | Higado de raton adulto (19–26 semanas) |

**Muestras seleccionadas para el analisis:**

| SRR | Condicion | Replica |
|---|---|---|
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
├── adapters/               # Archivo de adaptadores para Trimmomatic (TruSeq3-PE.fa)
├── align/
│   ├── kallisto/           # Resultados de pseudoalineamiento (abundance.tsv, abundance.h5)
│   └── STAR/               # Indice STAR y archivos de alineamiento (.bam, .ReadsPerGene.out.tab)
├── data/
│   ├── raw/                # Datos crudos descargados de SRA (.fastq.gz)
│   └── processed/          # Datos despues de Trimmomatic (_paired.fastq.gz, _unpaired.fastq.gz)
├── DEG_results/            # Resultados de expresion diferencial (DESeq2)
├── figures/                # Figuras generadas en el analisis (PCA, VolcanoPlot, Heatmap)
├── logs/                   # Logs de los programas ejecutados en el cluster
├── quality1/               # FastQC de datos crudos
├── quality2/               # FastQC post-Trimmomatic y reporte MultiQC
├── reference/              # Genoma de referencia y anotacion GTF
├── results_final/          # Resultados finales (CSVs DESeq2 y plots)
├── scripts/                # Scripts del pipeline
│   ├── trimmomatic_final.sh
│   ├── out_logs/           # SLURM outlogs de cada paso
│   ├── Entregable3_final.Rmd
│   └── Entregable3_final.html
├── metadata.csv            # Metadatos de las muestras
└── README.md
```

---

## Pipeline y scripts

### Paso 1: Control de calidad de datos crudos
**Programa:** FastQC v0.11.x + MultiQC  
**Input:** `data/raw/*.fastq.gz`  
**Output:** `quality1/` (reportes FastQC individuales)  
Se evaluo calidad Phred, contenido GC, duplicacion y presencia de adaptadores.

### Paso 2: Limpieza de adaptadores
**Programa:** Trimmomatic v0.39  
**Script:** `scripts/trimmomatic_final.sh`  
**Input:** `data/raw/*.fastq.gz`  
**Output:** `data/processed/*_paired.fastq.gz`, `data/processed/*_unpaired.fastq.gz`  
**Outlogs:** `scripts/out_logs/`  
Se removieron adaptadores TruSeq3 y lecturas de baja calidad (LEADING:3, TRAILING:3, SLIDINGWINDOW:4:15, MINLEN:36).

### Paso 3: Control de calidad post-trimming
**Programa:** FastQC + MultiQC  
**Input:** `data/processed/*_paired.fastq.gz`  
**Output:** `quality2/` (reportes FastQC + multiqc_report.html)

### Paso 4: Pseudoalineamiento y cuantificacion
**Programa:** Kallisto  
**Input:** `data/processed/*_paired.fastq.gz`  
**Output:** `align/kallisto/kallisto_quant/SRR*/abundance.tsv`

### Paso 5: Alineamiento
**Programa:** STAR  
**Input:** `data/processed/*_paired.fastq.gz`, indice en `align/STAR/STAR_index/`  
**Output:** `align/STAR/STAR_output/SRR*/*.Aligned.sortedByCoord.out.bam`, `*.ReadsPerGene.out.tab`

### Paso 6: Expresion diferencial
**Programa:** DESeq2 (R)  
**Script:** `scripts/Entregable3_final.Rmd`  
**Input:** `*.ReadsPerGene.out.tab` (STAR) y `abundance.tsv` (Kallisto)  
**Output:** `DEG_results/DESeq2_STAR_results.csv`, `DEG_results/DESeq2_kallisto_results.csv`  
Se realizo normalizacion rlog, PCA, volcano plot, heatmap y analisis de enriquecimiento GO.

---

## Archivos de resultados

| Archivo | Descripcion |
|---|---|
| `DEG_results/DESeq2_STAR_results.csv` | Genes diferencialmente expresados (STAR + DESeq2) |
| `DEG_results/DESeq2_kallisto_results.csv` | Genes diferencialmente expresados (Kallisto + DESeq2) |
| `figures/PCA_rlog_STAR.png` | PCA con normalizacion rlog (STAR) |
| `figures/PCA_rlog_kallisto.png` | PCA con normalizacion rlog (Kallisto) |
| `figures/VolcanoPlot_STAR.png` | Volcano plot (STAR) |
| `figures/VolcanoPlot.png` | Volcano plot (Kallisto) |
| `figures/Heatmap_STAR.pdf` | Heatmap de genes DEG (STAR) |
| `figures/Heatmap.pdf` | Heatmap de genes DEG (Kallisto) |
| `quality2/multiqc_report.html` | Reporte MultiQC post-trimming |

---

## Referencias

1. Dunn, A. et al., 2026. Altered hepatic metabolism in Down syndrome. *Cell Reports*. DOI: 10.1016/j.celrep.2025.116835

2. [Referencia adicional 2 — Autor, Año, Revista, DOI]

3. [Referencia adicional 3 — Autor, Año, Revista, DOI]

4. [Referencia adicional 4 — Autor, Año, Revista, DOI]
