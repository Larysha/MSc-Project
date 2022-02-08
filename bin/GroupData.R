# Set working directory and load dplyr package

# library(dplyr)

temp = list.files(pattern = ".*full.bed")

# loop through each file in temp and assign the file name to the R object 
for (i in 1:length(temp))
  assign(temp[i], read.table(temp[i], header = F, sep = "\t", fill = TRUE))


# The Untreated Files -----------------------------------------------------


# The HMEC and TF MDAMB231 files don't require further filtering since they only contain "untreated" samples.
# Need to give the variables the correct names for BED file format (otherwise Bedtools can't read them) and read into new files:

colnames(tfHMECfull.bed) <- c("chrom", "chromStart", "chromEnd", "Width", "ID", "Name", 
                      "Title", "Treatment", "10logMACSq", "Annotation", "DistanceToTSS")
write.table(tfHMECfull.bed, "tfHMEC_UT.bed", sep = "\t", quote = F, row.names = F)



colnames(hHMECfull.bed) <- c("chrom", "chromStart", "chromEnd", "Width", "ID", "Name", 
                     "Title", "Treatment", "10logMACSq", "Annotation", "DistanceToTSS")
write.table(hHMECfull.bed, "hHMEC_UT.bed", sep = "\t", quote = F, row.names = F)



colnames(tfMDAMB231full.bed) <- c("chrom", "chromStart", "chromEnd", "Width", "ID", "Name", 
                          "Title", "Treatment", "10logMACSq", "Annotation", "DistanceToTSS")
write.table(tfMDAMB231full.bed, "tfMDAMB231_UT.bed", sep = "\t", quote = F, row.names = F)


# The Treated Files -------------------------------------------------------

# Both MCF7 and histone MDAMB231 files need to be grouped according to treatment 

# The histone MCF7 file


# Estrogen treated histone MCF7 samples

hMCF7_E <- hMCF7 %>%  filter(hMCF7$Treatment == "Estrogen")
colnames(hMCF7_E) <- c("chrom", "chromStart", "chromEnd", "Width", "ID", "Name", 
                       "Title", "Treatment", "10logMACSq", "Annotation", "DistanceToTSS")
write.table(hMCF7_E, "hMCF7_E.bed", sep = "\t", quote = F, row.names = F)

# Untreated histone MCF7 samples
hMCF7_UT <- hMCF7 %>%  filter(hMCF7$Treatment == "none")
colnames(hMCF7_E) <- c("chrom", "chromStart", "chromEnd", "Width", "ID", "Name", 
                       "Title", "Treatment", "10logMACSq", "Annotation", "DistanceToTSS")
write.table(hMCF7_E, "hMCF7_E.bed", sep = "\t", quote = F, row.names = F)

# Tamoxifen treated histone MCF7 samples
hMCF7_TAMX <- hMCF7 %>%  filter(hMCF7$Treatment == "tamoxifen")
colnames(hMCF7_TAMX) <- c("chrom", "chromStart", "chromEnd", "Width", "ID", "Name", 
                       "Title", "Treatment", "10logMACSq", "Annotation", "DistanceToTSS")
write.table(hMCF7_TAMX, "hMCF7_TAMX.bed", sep = "\t", quote = F, row.names = F)

# Also taking out the jarid1b samples from the histone MCF7 file for later reference. 
hMCF7_JARID1B <- hMCF7 %>%  filter(hMCF7$Treatment == "jarid1b inhibitor")
colnames(hMCF7_JARID1B) <- c("chrom", "chromStart", "chromEnd", "Width", "ID", "Name", 
                          "Title", "Treatment", "10logMACSq", "Annotation", "DistanceToTSS")
write.table(hMCF7_JARID1B, "hMCF7_JARID1B.bed", sep = "\t", quote = F, row.names = F)


# -----------------------
# The TF MCF7 file

# Estrogen treated TF MCF7 samples
tfMCF7_E <- tfMCF7 %>% filter(tfMCF7$Treatment == "Estrogen")
colnames(tfMCF7_E) <- c("chrom", "chromStart", "chromEnd", "Width", "ID", "Name", 
                       "Title", "Treatment", "10logMACSq", "Annotation", "DistanceToTSS")
write.table(tfMCF7_E, "tfMCF7_E.bed", sep = "\t", quote = F, row.names = F)


# Untreated TF MCF7 samples
tfMCF7_UT <- tfMCF7 %>% filter(tfMCF7$Treatment == "none")
colnames(tfMCF7_UT) <- c("chrom", "chromStart", "chromEnd", "Width", "ID", "Name", 
                        "Title", "Treatment", "10logMACSq", "Annotation", "DistanceToTSS")
write.table(tfMCF7_UT, "tfMCF7_UT.bed", sep = "\t", quote = F, row.names = F)

#----------------------
# The histone MDAMB231 file

# Estrogen treated histone MDAMB231 samples
hMDAMB231_E <- hMDAMB231 %>% filter(hMDAMB231$Treatment == "Estrogen")
colnames(hMDAMB231_E) <- c("chrom", "chromStart", "chromEnd", "Width", "ID", "Name", 
                         "Title", "Treatment", "10logMACSq", "Annotation", "DistanceToTSS")
write.table(hMDAMB231_E, "hMDAMB231_E.bed", sep = "\t", quote = F, row.names = F)

# Untreated histone MDAMB231 samples
hMDAMB231_UT <- hMDAMB231 %>% filter(hMDAMB231$Treatment == "none")
colnames(hMDAMB231_UT) <- c("chrom", "chromStart", "chromEnd", "Width", "ID", "Name", 
                           "Title", "Treatment", "10logMACSq", "Annotation", "DistanceToTSS")
write.table(hMDAMB231_UT, "hMDAMB231_UT.bed", sep = "\t", quote = F, row.names = F)




