#!/bin/sh


# Find the overlapping features of the FIMO known TFBS from the scan of the PXDN promoter 
# and the experimental ChIP-Seq TF binding using the bedtools "intersect" command

#The option -wo (write overlap) reports the information from both files and reports the number of bp overlaps
# between features. The -f option sets a minimum threshold for reporting an overlap - in this case 30%

bedtools intersect -a fimo.bed -b tfHMECfimo.bed -wo -f 0.30 > tfHMECknownTFBS.bed


bedtools intersect -a fimo.bed -b tfMCF7fimo.bed -wo -f 0.30 > tfMCF7knownTFBS.bed


bedtools intersect -a fimo.bed -b tfMDAMB231fimo.bed -wo -f 0.30 > tfMDAMB231knownTFBS.bed







