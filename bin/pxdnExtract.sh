#!/bin/sh

### extract the PXDN specific regions from the ChIP-Seq bed files for the histone modification data


### Bedtools commands run for each file extraction in order to retain the experiment metadata from "file b"

bedtools intersect -wb -a regionPxdn.bed -b Histone_HMEC.bed > ~/Masters/data/work/filtered_full_histone_HMEC.bed

bedtools intersect -wb -a regionPxdn.bed -b Histone_MCF-7.bed > ~/Masters/data/work/filtered_full_histone_MCF-7.be

bedtools intersect -wb -a regionPxdn.bed -b Histone_MDA-MB-231.bed > ~/Masters/data/work/filtered_full_histone_MDA-MB-231.bed


### extract the PXDN specific regions from the ChIP-Seq bed files for the TF data

bedtools intersect -wb -a regionPxdn.bed -b TF_HMEC.bed > ~/Masters/data/work/filtered_full_TF_HMEC.be

bedtools intersect -wb -a regionPxdn.bed -b TF_MCF-7.bed > ~/Masters/data/work/filtered_full_TF_MCF-7.bed

bedtools intersect -wb -a regionPxdn.bed -b TF_MDA-MB-231.bed > ~/Masters/data/work/filtered_full_TF_MDA-MB-231.bed
