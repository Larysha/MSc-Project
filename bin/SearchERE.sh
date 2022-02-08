#!/bin/bash

# Navigate to the working directory containing the ESR1 ChIP-Seq 
# binding site fasta sequences
# cd  Documents/MSc-Project/work/Final\ Files/ERE

# Search the oestrogen treated ER alpha ChIP-Seq peaks for :
# The first ERE half-site, followed by the a 3 bp spaces and the second half-site
# The -B option retains the first line above the sequence to retain fasta formatting in the
# output files and to find the ERE coordinate later since there are mulitple fasta sequences per file.
grep -B 1 -E 'AGGTCA[ACGT]{3}TGACCT' tfMCF7_E_ESR1.fa > tfMCF7_E_ERE.fa
# no results; search for the half sites seperately 

# The frst half site is present in the sequences; read into new file
grep -B 1 -E 'AGGTCA[ACGT]{3}' tfMCF7_E_ESR1.fa > tfMCF7_E_ERE.fa
# test for the second half-site seperately; no occurances
grep -B 1 -E 'TGACCT' tfMCF7_E_ESR1.fa

# Repeat for the untreated MCF-7 filesystem
grep -B 1 -E 'AGGTCA[ACGT]{3}' tfMCF7_UT_ESR1.fa
grep -B 1 -E 'TGACCT' tfMCF7_UT_ESR1.fa
