#!/bin/bash

# Navigate to the working directory containing the antigen bed files
# cd Documents/MSc-Project/work/Final\ Files/DeNovoMotif/
# download chromosome 2 from the UCSC and store in a zipped, fasta file
wget --timestamping 'ftp://hgdownload.cse.ucsc.edu/goldenPath/hg19/chromosomes/chr2.fa.gz' -O chr2.fa.gz
gunzip -k chr2.fa.gz

# assign the coordinate files to a variable
files="*.bed"

# loop through the files to retain only the 1st 3 columns and remove the header
# the files are then ready for bedtools to retrieve the fasta sequences
for file in $files; do
cut -f 1,2,3 $file | sed '1d' > $file.cut
bedtools getfasta -fi chr2.fa -bed $file.cut -fo "$file".fa;
done


#to run each step of the loop separately:

#print the list of files to make sure the correct files are listed
#for file in "$files"; do echo $file; done

#for file in $files; do cut -f 1,2,3 $file > $file.cut.bed; done

#files="*.cut.bed"
#for file in $files; do sed -i '1d' $file; done

#files="*.cut.bed"

#for file in $files; do bedtools getfasta -fi chr2.fa -bed $file -fo "$file".fa; done


