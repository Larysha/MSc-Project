---------------------------
  ####CHIP-SEQ FILE PREPARATION
---------------------------
 
# Load the relevant packages  

library(dplyr)
library(GenomicRanges)
  
   
# Read in the ChIP-Seq data - pre-filtered in Bedtools to contain the region specific to PXDN chr2:1655000;1760000 
# create a list called temp containing all bed files in the work directory. 
temp = list.files(pattern = ".*.bed")

# loop through each file in temp and assign the file name to the R object 
for (i in 1:length(temp))
  assign(temp[i], read.table(temp[i], header = F, sep = "\t", fill = T))


  
  ### The full files have duplicated columns (4-7) that need to be removed. Re-write those
  ### files into the correct format and give the variables descriptive (and shorter) names to keep track of them 
  
  histone_HMEC.bed <- filtered_full_histone_HMEC.bed %>% dplyr::select(!c(V4:V6, V9:V12)) 
  histone_HMEC.bed <- na.omit(histone_HMEC.bed)
  histone_MCF_7.bed <- filtered_full_histone_MCF_7.bed %>% dplyr::select(!c(V4:V6,V9:V12))
  histone_MCF_7.bed <- na.omit(histone_MCF_7.bed)
  histone_MDA_MB_231.bed <- filtered_full_histone_MDA_MB_231.bed %>% dplyr::select(!c(V4:V6,V9:V12))
  histone_MDA_MB_231.bed <- na.omit(histone_MDA_MB_231.bed)
  
  TF_HMEC.bed <- filtered_full_TF_HMEC.bed %>% dplyr::select(!c(V4:V6,V9:V12))
  TF_HMEC.bed <- na.omit(TF_HMEC.bed)
  TF_MCF_7.bed <- filtered_full_TF_MCF_7.bed %>% dplyr::select(!c(V4:V6,V9:V12))
  TF_MCF_7.bed <- na.omit(TF_MCF_7.bed)
  TF_MDA_MB_231.bed <- filtered_full_TF_MDA_MB_231.bed %>% dplyr::select(!c(V4:V6,V9:V12))
  TF_MDA_MB_231.bed <- na.omit(TF_MDA_MB_231.bed)
  
  
  ## make a list of the files to loop through for faster editing
  files = list(histone_HMEC.bed, histone_MCF_7.bed, histone_MCF_7.bed, 
               histone_MDA_MB_231.bed, TF_HMEC.bed, TF_MCF_7.bed, TF_MDA_MB_231.bed)  
  
  # create a list of names for the files
  data_names <- c('histoneHMEC.bed', 'histoneMCF7.bed', 'histoneMDAMB231.bed', 'tfHMEC.bed', 'tfMCF7.bed', 'tfMDAMB231.bed')

# rename the 5 remaining variables in the bed files
for (file in files) {
  colnames(file) = c("chr",
                     "start",
                     "end",
                     "metadata",
                     "-10logMacsq") 
}


  # write these new data frames into bed files for permanent storage
  # first create a new directory to store the files
  
  dir.create("~/MSc-Project/MSc/work/Unannotated Files")
  
# Write the new data frames into files using the names from the data_names list
  
for (file in 1:length(data_names)) {
  write.table(get(data_names[file]),
              paste0("~/MSc-Project/MSc/work/Unannotated Files/",
                     data_names[file]),
              sep = "\t", quote = F, row.names = F)
}
  
  
  ### each object has to be converted to GRanges format for ChIPseeker to recognize the peak files
  
 for (file in files){
   makeGRangesFromDataFrame(file, keep.extra.columns = T)
 }
  
  
# ChIP-Seq Annotation -----------------------------------------------------

    
# Annotate the ChIP-Seq data with ChIPseeker
# Load the necessary libraries 
    
  library(dplyr)
  library(clusterProfiler)
  library(ChIPseeker)
  library(TxDb.Hsapiens.UCSC.hg19.knownGene)
  # This draws on an annotation databases generated from UCSC by exposing these as TxDb objects
  txdb <- TxDb.Hsapiens.UCSC.hg19.knownGene
  # Limit this object to chromosome 2
  seqlevels(txdb) <- "chr2"
  
  
  # Use the ChIPseeker package to annotate the data
  
  for (file in files){
    annotatePeak(tssRegion = c(-1000,5000), TxDb=txdb, level = "gene", verbose=FALSE)
  }
  
  # Rename the list to reflect annotation
  data_names2 <- c('histoneHMECanno', 'histoneMCF7anno', 'histoneMDAMB231anno', 
                   'tfHMECanno', 'tfMCF7anno', 'tfMDAMB231anno')
  
  names(files) <- data_names2
  
  ### make a list of the annotation files for visualization according to feature distribution
  
  peakAnnoList_hist <- c(HMEC_Peaks = histoneHMECanno, MCF7_Peaks = histoneMCF7anno, MDA_MB_231_Peaks = histoneMDAMB231anno)
  plotAnnoBar(peakAnnoList_hist)
  # Build in visualization function with the ChIPseeker package
  plotDistToTSS(peakAnnoList_hist, title="Distribution of histone modifications relative to TSS according to cell type")
  
  # Repeat for the TF files
  peakAnnoList_tf <- c(HMEC_Peaks = tfHMECanno, MCF7_Peaks = tfMCF7anno, MDA_MB_231_Peaks = tfMDAMB231anno)
  plotAnnoBar(peakAnnoList_tf)
  plotDistToTSS(peakAnnoList_tf, title="Distribution of TF binding loci relative to TSS according to cell type")
  
  
  ### Convert the annotation files into data frames to write into tables
  
  # first create a new directory to store the files
  
  dir.create("~/MSc-Project/MSc/work/Annotated Files")
  
  
  for (file in files){
    as.data.frame(file)
  }
  
  # Write the new data frames into files using the names from the data_names2 list
  
  for (file in files) {
    write.table(get(data_names2[file]),
                paste0("~/MSc-Project/MSc/work/Annotated Files/",
                       data_names2[file],
                       ".tsv"),
                sep = "\t", quote = F, row.names = F)
  }
  
  
  ## The metadata from these files is extracted and sorted in the CleanMetadata.sh script
