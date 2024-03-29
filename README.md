# ChIP-Seq Single-Gene Downstream Analysis

This project aims to understand the mechanism of regulation of the *PXDN* gene in breast cancer. Specifically to identify the transcription factors (TF) and histone modifications (HM) (acetylation and methylation in particular) regulating *PXDN* expression and the *PXDN* chromatin state respectively in MCF-7, MDA-MB-231 and HMEC cell lines.

### The following objectives were set to achieve this:

1.  To determine all potential *PXDN* TFBS, the *PXDN* promoter was scanned for known TFBS motifs (represented by matrices stored in the JASPAR database) using the MEME suite software FIMO.

2.  To identify TFs, their binding sites and histone modifications within 5 000 bps UPSTREAM of the PXDN TSS, publicly available TF and histone ChIP-Seq data was filtered and annotated (in ChIPseeker). The TF binding peaks were compared to the known TFBS identified by FIMO to determine the degree of overlap between the predicted binding sites and the ChIP-Seq peaks.

3.  To compare binding between cell lines and overlap between the histone and TF data, Bedtools was used to compare binding peaks. This data was visualised and annotated to the PXDN promoter and surrounding region according to cell line and treatment type.

# Objective 1

## 1.0 FIMO Scan

All vertebrate TFBS motifs (present on both strands, with 25% background letter frequencies) were downloaded from the JASPAR database (MEME version 4 format). The output is stored in the VertebrateMotifs.meme file.

TFBS motifs can be accessed and dowloaded in batch with JASPAR2020 and TFBSTools R/Bioconductor packages as a list of position frequency matrices: https://bioconductor.org/packages/release/data/annotation/vignettes/JASPAR2020/inst/doc/JASPAR2020.html


The *PXDN* promoter (5' flanking sequence upstream of *PXDN* on the negative strand) was defined as the region chr2:1748625-1754624 (genome version hg19) and downloaded from Ensembl Release 104 (accessed 5 June 2021), using the "Feature Strand" option. This is saved to the output file PxdnPromoter.fasta

The FIMO tool - accessed through meme-5.3.3 - was used to scan the PXDN promoter for sequences that matched the known TFBS, using the following command:

``` sh
fimo --parse-genomic-coord VertebrateMotifs.meme PxdnPromoter.fasta
```

The `--parse-genomic-coord` option ensures that the output file gives the matching patterns as genomic coordinates and not relative to the first base of the promoter, which is the default setting.

It is also useful to note that this command only runs from the project directory when meme is added to the system bin. This can be done by editing your `.profile file` to include the following line: `export PATH=/home/username/meme/bin:/home/username/meme/libexec/meme-5.3.3:$PATH` Note that the path will be specific to the location of the saved meme application, the meme version number and your own username.

FIMO produces five output files, by default. The matches are sorted in order of decreasing statistical significance (increasing p-value). The fimo.tsv file was read into `R-4.1.0` and converted into BED file format using the package dplyr, according to the format outlined by the UCSC.


# Objective 2

## 2.0 ChIP-Seq file preparation

The ChIP-Seq data was downloaded in BED file format from the ChIP-Atlas database using the "Peak Browser" tool (2021-05-18).

The following parameters were set: antigen class = "TF and others" & "Histone"; cell type class = "Breast"; threshold for significance = "200"; antigen = "all", cell type = "MCF-7" & "MDA-MB-231" & "HMEC".

Since these files contain genome-wide data, filtering is required so that only the data specific to the *PXDN* region is retained. This was done with Bedtools v2.27.1. The file named `regionPxdn.bed` contains the rounded co-ordinates of the full *PXDN* gene region.

Bedtools `intersect` was applied to each ChIP-Seq file with the region defined for *PXDN*. The results were written as an overlap of the ChIP-Seq files so that all metadata could be retained.

Note, Bedtools can be installed in the command line (in a Debian distribution) with the following:

``` sh
sudo apt install bedtools
```

Filtering example:

``` sh
bedtools intersect -wb -a regionPxdn.bed -b Histone_HMEC.bed > ~/Masters/data/work/Filtered_Histone_HMEC.bed
```


## 2.1. Annotation in R with ChIPseeker

The data peaks were annotated with the Bioconductor package ChIPseeker v1.28.3, which maps ChIP-Seq peaks to gene "features" according to distribution around the gene transcription start site (TSS) - refer to <http://bioconductor.org/packages/release/bioc/vignettes/ChIPseeker/inst/doc/ChIPseeker.html>.

The filtered ChIP-Seq files were read into R-4.1.0 to be cleaned, given descriptive variable names and converted into GRanges objects (from data frames). Note that the annotation steps in ChIPseeker do not run until the data is in the form of a GRanges object.

For the histone files, tssRegion = c(-5000,5000), since these patterns can have a far-reaching effect. For the TF files, tssRegion = c(-1500,5000) since the promoter is the primary region of interest. However, there may be multiple TSS regions within the gene (for different splice variants), so it might be useful to see TFBS within the gene and introns, too. ChIPseeker also provides tools for the visualization of data according to feature distribution.

Full script: `ChIP-SeqAnnotation.R`

## 2.2 Dealing with the metadata

The fully annotated files contain a metadata column (inherited from ChIP-Atlas), which has 27 entries detailing everything from the laboratory where the experiment was conducted to the antibody target. It also includes the treatment and control conditions of the experiment, which are important for binding interpretation. Before anything else is done with the data, the metadata needs to be extracted and sorted into its own variables.

First, the 9th to 14th columns are removed from the files - they contain the variables `geneChr; geneStart; geneEnd; geneLength; geneStr; geneId`. Since there is only one gene of interest in this analysis (*PXDN*) this information is not useful. Next, the metadata column is reorganised so that the `%20` deliminator is removed and replaced with a single space.

Example

``` sh
cut --complement -f 9-14 input.tsv | sed 's/%20/ /g' > output.tsv
```

Full script: `CleanMetadata.sh`

Each metadata entry is read into its own column. The `Perl` tool `Text::CSV` is used for this.

Full script: `process-tsv.pl`

Text::CSV is a perl package that can be downloaded on a Debian distribution with

``` sh
sudo apt install libtext-csv-perl
```

This script is run for each file with the following command (example for one file):

``` sh
chmod +x process-tsv.pl
./process-tsv.pl input.tsv > output.tsv
```

The cleaned files are then read into R. After some preliminary analysis of the treatment metadata, it was discovered that over half the treatment values were missing for the MCF7 files. These values were manually referenced using the sample SRX and GSM IDs. The `process-tsv` script failed to correctly sort the histone MDAMB231 file and so this was done with a slower approach in R with the dplyr package - and missing treatment values for the MDA-MB-231 files were also manually referenced.

Full script: `ExploringMetadata.R`

The treatment conditions for the samples with missing values were entered into the existing R dataframes and written into new, complete files.

Full script: `SortingMetadata.R`

Once the treatment data was obtained, the samples could be grouped according to treatment conditions. Oestrogen and Untreated samples were selected and read into their own files for each cell line and antigen type. These files also underwent formatting changes in preparation for the data comparison in Bedtools.

Full script: `GroupData.R`

## 2.3 Data comparison: FIMO Predictions

The TF binding sites from the ChIP-Seq files were compared with the predicted binding sites identified by FIMO using Bedtools `intersect`. The files were compared with the -f option (minimum threshold for reporting an overlap) at 30% and was then removed altogether - in each case there was no overlap between the predicted and actual TF binding sites.

Full Script: `FimoChip-SeqIntersect.sh`

# Objective 3

## 3.0 Transcription factor binding motif analysis

The data for each antigen was read into seperate files and the aligned ChIP-Seq reads were visualised with the Integrative Genomics Viewer (IGV) to see more clearly where the TFBS and HMs occur in the PXDN gene for each cell line and treatment category. The question that arose was: if an antigen peak has been shown to appear in and around PXDN in a particular cell line, but doesn’t appear for this region in another – is it because the antigen does not occur or because the relevant ChIP-Seq experiment has not been performed yet? To answer this question, the original, genome-wide ChIP-Seq experiment files were scanned for each of the antigens in figure 4, to determine which cell lines (and under what conditions) each antigen experiment had been conducted in. Based on this, select antigens were filtered out for further analysis.


## 3.1 ChIP-Seq FIMO scan 

The FIMO predictions in 2.3 resulted in no overlaps with the known motifs. This was likely because the FIMO scan was initially restricted to the promoter and upstream regions of _PXDN_, while the ChIP-Seq data revealed that the majority of TFBS occur within the gene itself.  Thus, the FIMO scan was re-run to focus on the TFBS identified by the ChIP-Seq peaks.

First, the FASTA DNA sequences corresponding to the coordinates of the ChIP-Seq peaks were downloaded (`RetriveFasta.sh`). Then, the FASTA sequences were searched with FIMO, as before, based on the VertebrateMotifs.meme file from the JASPAR database. This second scan yieled 7 unique known binding motifs for the TF found to bind _PXDN_. These motifs were compared between cell lines to see if the TF that bind and regulate _PXDN_ in different cell lines or in differnt treatment condtions bind to different motifs/ in different places.


Example:

``` sh
fimo --oc . --verbosity 1 --thresh 1.0E-4 VertebrateMotifs.meme tfMCF7_UT.fa
```


## 3.2 Searching for oestrogen response elements (ERE)

In addition to known TFBS stored in the JASPAR database, the palindromic consensus ERE was searched for in the regions where the oestrogen receptor (ER) appears to bind. The FASTA DNA sequences corresponding to the ER ChIP-Seq peaks were searched for the AGGTCAnnnTGACCT conserved motif using the command line tool, grep (`SearchERE.sh`). There are two half sites to this motif and point mutations to either half site can decrease affinity of the ER for the ERE. Since the putative binding sites of the ER are already known from the ChIP-Seq analysis and given that strong ER-ERE associations require at least one perfect half site to be present in the sequence, the grep tool is sufficient to search for an exact match to either of the half sites.






