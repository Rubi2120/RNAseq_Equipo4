.libPaths(c("~/R/library", .libPaths()))
library(clusterProfiler)
library(org.Mm.eg.db)
library(ggplot2)

res <- read.csv("/mnt/data/bioinfo-estadistica-2/RNAseq_2026/equipos/Equipo4/results_final/GSEA_GO_results.csv")

gsea_go <- res

# Guardar como PDF (funciona sin X11)
pdf("/mnt/data/bioinfo-estadistica-2/RNAseq_2026/equipos/Equipo4/results_final/plots/GSEA_dotplot.pdf",
    width=12, height=8)
ggplot(head(res[order(res$pvalue),], 20), 
       aes(x=NES, y=reorder(Description, NES), size=setSize, color=pvalue)) +
  geom_point() +
  scale_color_gradient(low="red", high="blue") +
  theme_bw() +
  labs(title="GSEA GO - Dp16 vs WT", x="NES", y="GO Term")
dev.off()

cat("Plot guardado!\n")
