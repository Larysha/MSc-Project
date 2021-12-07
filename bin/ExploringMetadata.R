

# Exploring, Cleaning and Selecting the Metadata Entries  -----------------

### Read in the files - with sorted metadata columns

hHMEC <- read.table("hisHMEC_1.tsv", header = T, sep = "\t")
hMCF7 <- read.table("hisMCF7_1.tsv", header = T, sep = "\t")
### Refer to section below for the sorting of the MDA file

tfHMEC <- read.table("tfHMEC_1.tsv", header = T, sep = "\t")
tfMCF7 <- read.table("tfMCF7_1.tsv", header = T, sep = "\t")
tfMDAMB231 <- read.table("tfMDAMB231_1.tsv", header = T, sep = "\t")


### Remove unnecessary strings and columns from the data frames 

hHMEC$Name <- gsub("@ HMEC", " ", hHMEC$Name) ### remove repeated characters
hHMEC$Title <- gsub("(:).*", "", hHMEC[,7])
hHMEC <- hHMEC[c(1:7,31:33)] ### select the relevant metadata columns
write.table(hHMEC, "hHMEC_2.tsv", sep = "\t", quote = F) ### read into new file

### repeat for all files  - columns that are retained differ depending on file format 
### although the same information is kept for each file

hMCF7$Name <- gsub("@ MCF-7", " ", hMCF7$Name)
hMCF7$Title <- gsub("(:).*", "", hMCF7[,7])
hMCF7 <- hMCF7[c(1:7,15,17:19)]
write.table(hMCF7, "hMCF7_2.tsv", sep = "\t", quote = F)


tfHMEC$Name <- gsub("@ HMEC", " ", tfHMEC$Name)
tfHMEC$Title <- gsub("(:).*", "", tfHMEC[,7])
tfHMEC <- tfHMEC[c(1:7,13:15)]
write.table(tfHMEC, "tfHMEC_2.tsv", sep = "\t", quote = F)


tfMCF7$Name <- gsub("@ MCF-7", " ", tfMCF7$Name)
tfMCF7$Title <- gsub("(:).*", "", tfMCF7[,7])
tfMCF7 <- tfMCF7[c(1:7,11, 16:18)]
write.table(tfMCF7, "tfMCF7_2.tsv", sep = "\t", quote = F)

tfMDAMB231$Name <- gsub("@ MDA-MB-231", " ", tfMDAMB231$Name)
tfMDAMB231$Title <- gsub("(:).*", "", tfMDAMB231[,7])
tfMDAMB231 <- tfMDAMB231[c(1:7, 12:14)]
write.table(tfMDAMB231, "tfMDAMB231_2.tsv", sep = "\t", quote = F)



# Sorting the hMDAMB231 file ----------------------------------------------
# A slower approach to the process-tsv.pl script
  
library(tidyr)
library(dplyr)

### Read in the file
hMDAMB231 <- read.table("hisMDAMB231annoFilt.tsv", header = T, sep = "\t")

# Separate the entries in the metadata column into their own variables
hMDAMB231 <- separate(hMDAMB231, metadata, into = c('ID', 'Name', 'Title'), sep =";")

### Clean up the "Names" column
hMDAMB231names <- sub(pattern = "%20.*", "", hMDAMB231$Name)
hMDAMB231names <- sub(pattern = ".*=", "", hMDAMB231names)
hMDAMB231$Name <- hMDAMB231names

### Clean up the "ID" column
hMDAMB231id <- sub(pattern = ".*ID=", "", hMDAMB231$ID)
hMDAMB231$ID <- hMDAMB231id

### Clean up the "Title" column
hMDAMB231Title <- sub(pattern = ".*Title=", "", hMDAMB231$Title)
hMDAMB231$Title <- hMDAMB231Title

# Retain only the relevant variables 
hMDAMB231 <- hMDAMB231 %>% select(c(seqnames, start, end, width, ID, Name, Title, X.10logMacsq,
                                    distanceToTSS, annotation))


## Clean up the columns a bit further - removing unnecessary strings and columns

hMDAMB231$Name <- gsub("@ MDA-MB-231", "", hMDAMB231$Name)### remove unnecessary characters 
hMDAMB231$Title <- sub("(:).*", "", hMDAMB231[,7])

write.table(hMDAMB231, "hMDAMB231_2.tsv", sep = "\t", quote = F) ### read into new file


# --------------------------------------


## Individually go through each file's metadata: treatment and controls. 
  ## Many of the treatments have to be manually referenced using the SRX and GSM accession numbers

