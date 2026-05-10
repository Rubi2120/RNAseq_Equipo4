options(timeout = 600)

# Descargar GTF primero
download.file(
  'https://ftp.ebi.ac.uk/pub/databases/gencode/Gencode_mouse/release_M24/gencode.vM24.annotation.gtf.gz',
  destfile = '/Users/dubsirubs/Desktop/RNAseq_Equipo4/gencode.vM24.annotation.gtf.gz',
  method = 'curl'
)

library(GenomicFeatures)
library(txdbmaker)

txdb <- makeTxDbFromGFF(
  '/Users/dubsirubs/Desktop/RNAseq_Equipo4/gencode.vM24.annotation.gtf.gz',
  format = 'gtf'
)

transcripts_info <- transcripts(txdb, columns = c('TXNAME', 'GENEID'))
tx2gene <- data.frame(
  TXNAME = transcripts_info$TXNAME,
  GENEID = unlist(transcripts_info$GENEID)
)

write.csv(tx2gene, '/Users/dubsirubs/Desktop/RNAseq_Equipo4/results_final/tx2gene_vM24.csv', row.names = FALSE)
cat('tx2gene generado:', nrow(tx2gene), 'transcritos\n')
