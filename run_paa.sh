#!/bin/bash
echo This is working

SAMPLE_NAME=$1
N_THREADS=$2
BAM_PROVIDED=$3
BAM_FILE=$4
FASTQ1=$5
FASTQ2=$6
RUN_AA=$7
PLOIDY=$8
PURITY=$9
CNVKITSEGMENT=${10}
BEDFILE=${11}

#wget -P /home/data_repo/ https://datasets.genepattern.org/data/module_support_files/AmpliconArchitect/${11}.tar.gz
#tar -xf /home/data_repo/$REFERENCE.tar.gz --directory /home/data_repo
echo $SAMPLE_NAME
echo $N_THREADS
echo $BAM_PROVIDED
echo $BAM_FILE
echo $FASTQ1
echo $FASTQ2
echo $RUN_AA
echo $PLOIDY
echo $PURITY
echo $CNVKITSEGMENT
echo $BEDFILE


echo Finished Running
