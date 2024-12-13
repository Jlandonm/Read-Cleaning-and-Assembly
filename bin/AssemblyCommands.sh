#!/bin/sh
        #### create environment ####
# conda create -n assembly -c bioconda shovill -y

#assembler and fileHeader variables
assembler=$2
fileHeader=$3

#running shovill on subset of files
shovill --outdir ${assembler}_${fileHeader} --R1 ${fileHeader}_R1.fastq.gz --R2 ${fileHeader}_R2.fastq.gz --assembler ${assembler}