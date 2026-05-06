.libPaths(c("~/R/library", .libPaths()))
library(dplyr)
library(clusterProfiler)
library(org.Mm.eg.db)
library(ggplot2)
options(bitmapType="cairo")

# Cargar resultados DESeq2
res <- read.csv("/mnt/data/bioinfo-estadistica-2/RNAseq_2026/equipos/Equipo4/results_final/DESeq2_kallisto_results.csv", row.names=1)

# Extraer nombre del gen del ID largo
res$gene_name <- sapply(strsplit(rownames(res), "\\|"), `[`, 6)

# Filtrar genes significativos
sig <- res[!is.na(res$padj) & res$padj < 0.05, ]
cat("Genes significativos:", nrow(sig), "\n")

# Lista para GSEA (todos los genes ordenados por log2FC)
gene_list <- res$log2FoldChange
names(gene_list) <- res$gene_name
gene_list <- sort(gene_list[!is.na(gene_list)], decreasing=TRUE)

# Convertir a Entrez IDs
entrez <- bitr(names(gene_list), fromType="SYMBOL", toType="ENTREZID", OrgDb=org.Mm.eg.db)
gene_list_entrez <- gene_list[entrez$SYMBOL]
names(gene_list_entrez) <- entrez$ENTREZID

# GSEA GO
gsea_go <- gseGO(geneList=gene_list_entrez, OrgDb=org.Mm.eg.db,
                 ont="BP", minGSSize=10, maxGSSize=500,
                 pvalueCutoff=0.05, verbose=FALSE)

# Guardar resultados
write.csv(as.data.frame(gsea_go), 
          "/mnt/data/bioinfo-estadistica-2/RNAseq_2026/equipos/Equipo4/results_final/GSEA_GO_results.csv",
          row.names=FALSE)

# Dotplot
png(type="cairo", "/mnt/data/bioinfo-estadistica-2/RNAseq_2026/equipos/Equipo4/results_final/plots/GSEA_dotplot.png",
    width=1200, height=800)
dotplot(gsea_go, showCategory=20, title="GSEA GO - Dp16 vs WT")
dev.off()

cat("GSEA completado!\n")
cat("Terminos enriquecidos:", nrow(as.data.frame(gsea_go)), "\n")
