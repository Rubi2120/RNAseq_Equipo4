ab <- read.table("results/kallisto/SRR33445252/abundance.tsv", header=TRUE, sep="\t")
ids <- strsplit(ab$target_id, "\\|")
tx2gene <- data.frame(
  TXNAME = sapply(ids, `[`, 1),
  GENEID = sapply(ids, `[`, 2)
)
write.csv(tx2gene, "results_final/tx2gene_kallisto.csv", row.names=FALSE)
cat("tx2gene generado:", nrow(tx2gene), "transcritos\n")
