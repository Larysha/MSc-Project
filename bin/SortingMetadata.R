
# Load the relevant packages

library(tibble)
library(dplyr)

### Read in the files - sorted in the "ExploringMetadata.R" script

temp = list.files(pattern = ".*.tsv")

# loop through each file in temp and assign the file name to the R object 
for (i in 1:length(temp))
  assign(temp[i], read.table(temp[i], header = T, sep = "\t"))


# Add Treatments ----------------------------------------------------------

# Most of these treatments were manually referenced using the samples SRX IDs. 
# The treatment conditions are now recorded using the sample row index before writing the updates data frames into new files


### create a directory to read the output files into
dir.create("~/R/Masters/data/work/Metadata Files")

## move into this directory with `setwd(dir/path)` before creating new files

# The HMEC Cell Line ------------------------------------------------------
# These files are untreated - this simply needs to be recorded before writing the new files

### The histone file

hHMEC_2.tsv$Treatment <- "none"
hHMEC <- hHMEC_2.tsv %>% relocate(Treatment, .after = Title)
write.table(hHMEC, "hHMECfull.bed", sep = "\t", quote = F, row.names = F) 

### The tf file

tfHMEC_2.tsv$Treatment <- "none"
tfHMEC <- tfHMEC_2.tsv %>% relocate(Treatment, .after = Title)
write.table(tfHMEC, "tfHMECfull.bed", sep = "\t", quote = F, row.names = F) 

# The MCF7 cell line ------------------------------------------------------

### The histone file

rn <- rownames(hMCF7_2.tsv)
hMCF7 <- cbind(rn=rn, hMCF7_2.tsv)

### assign treatments to the "Treatment" columns according to row index

hMCF7$Treatment[hMCF7$rn %in% c(22, 68, 264, 71, 205, 74, 141, 169, 199, 248,
                                257, 260, 261, 277, 224, 263, 265, 266, 269, 270, 49,
                                53,  56, 58,  61,  62,  65,  67,  70,  80, 135, 146, 151, 156, 157, 175, 177, 179)] <- "Estrogen" 
hMCF7$Treatment[hMCF7$rn %in% c(95, 150, 165, 172, 182, 188, 192, 194, 195, 197, 203, 210, 211, 214, 253, 276)] <- "none"
hMCF7$Treatment[hMCF7$rn %in% c(19, 20, 252, 122, 131, 18,21, 250)] <- "GATA knockdown"
hMCF7$Treatment[hMCF7$rn %in% c(27, 116, 240, 278, 38, 162, 44, 164, 45,  154, 46, 155, 75,
                                171, 81, 158, 84, 178, 92, 190, 192, 196, 206, 213, 246, 254)] <- "jarid1b inhibitor"
hMCF7$Treatment[hMCF7$rn %in% c(24, 26, 113, 115, 279, 48, 142)] <- "non-specific siRNA"               
hMCF7$Treatment[hMCF7$rn %in% c(217, 244, 247)] <- "shMEN1"
hMCF7$Treatment[hMCF7$rn %in% c(43,144)] <- "shNR2F2"
hMCF7$Treatment[hMCF7$rn %in% c(85, 118, 152, 105, 173)] <- "siGRHL2"
hMCF7$Treatment[hMCF7$rn %in% c(25, 51, 163, 54, 55, 143, 59, 251, 60, 63, 256, 66, 129, 148, 202, 251)] <- "TAMR"
 
### standardize the way the treatment values are recorded
hMCF7["Treatment"][hMCF7["Treatment"] == "E2"] <- "Estrogen"
hMCF7["Treatment"][hMCF7["Treatment"] == "e2"] <- "Estrogen"
hMCF7["Treatment"][hMCF7["Treatment"] == "Control"] <- "none"

### use: unique(hMCF7$Treatment)
### to see which treatment categories can be merged and standardized


### Keep only the data with treatment values 
hMCF7_3 <- hMCF7 %>% filter(Treatment != "")   
hMCF7_3$rn <- NULL 
write.table(hMCF7_3, "hMCF7full.bed", sep = "\t", quote = F, row.names = F)  



### The tf file  

rn <- rownames(tfMCF7)
tfMCF7 <- cbind(rn=rn, tfMCF7)

tfMCF7$Treatment[tfMCF7$rn %in% c(4, 16:20, 22, 24:29, 31, 33:37, 39, 41:47, 49, 50, 51, 54, 
                                  55, 56, 60, 62, 64, 68, 71:78, 81:84, 86:96, 98, 100, 102:111)] <- "Estrogen"
tfMCF7$Treatment[tfMCF7$rn %in% c(52, 58)] <- "fulvestrant"
tfMCF7$Treatment[tfMCF7$rn %in% c(14, 23, 65, 70, 85, 97, 99, 79)] <- "none"

write.table(tfMCF7_3, "tfMCF7full.bed", sep = "\t", quote = F, row.names = F) 


# The MDA_MB_231 Cell Line ------------------------------------------------


### The histone file

hMDAMB231 <- hMDAMB231_2.tsv %>%
  add_column(Treatment = NA)

hMDAMB231 <- hMDAMB231 %>% relocate(Treatment, .after = Title)

hMDAMB231$Treatment[hMDAMB231$rn %in% c(43, 98, 46, 37,  97, 106)] <- "YAP/TAZ siRNA"
hMDAMB231$Treatment[hMDAMB231$rn %in% c(2, 16, 18, 68, 5, 12, 22, 53, 6, 25, 41, 65, 20, 21, 31, 45, 64, 33)] <- "Estrogen"
hMDAMB231$Treatment[hMDAMB231$rn %in% c(1, 3, 7, 11, 51, 56, 9, 24, 47, 61, 72, 101, 104, 13, 17, 58, 73, 
                                        95, 19, 39, 23, 40, 62, 28, 40, 62, 28, 52, 29, 70, 85, 32, 44, 34, 54,
                                        99, 50, 66, 75, 91, 107, 77, 84, 78, 96, 80, 86, 8, 26, 42, 59, 100, 105,
                                        10, 27, 60, 69, 102, 103)] <- "none"

hMDAMB231$Treatment[hMDAMB231$rn %in% c(74,89,81,90)] <- "non-specific siRNA"
hMDAMB231$Treatment[hMDAMB231$rn %in% c(83, 92, 76, 93)] <- "shSET1B"
hMDAMB231$Treatment[hMDAMB231$rn %in% c(35, 79, 88)] <- "shSATB1"

hMDAMB231 <- hMDAMB231 %>% filter(Treatment != "")
hMDAMB231$rn <- NULL 

write.table(hMDAMB231, "hMDAMB231full.bed", sep = "\t", quote = F, row.names = F) 


### The tf file

tfMDAMB231_2.tsv$Treatment <- "none"
tfMDAMB231 <- tfMDAMB231_2.tsv %>% relocate(Treatment, .after = Title)
tfMDAMB231 <- tfMDAMB231[1:18,] ### remove the last sample rowO

write.table(tfMDAMB231, "tfMDAMB231full.bed", sep = "\t", quote = F, row.names = F) 






