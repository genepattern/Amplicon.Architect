#!/bin/bash
echo This is working
SAMPLE_NAME=$1
N_THREADS=$2
REFERENCE=$3
BAM_PROVIDED=$4

# From jluebeck/PrepareAA repo. Setting environmental arguments
AA_DATA_REPO=/home/data_repo
export AA_DATA_REPO
AA_SRC=/home/programs/AmpliconArchitect-master/src
export AA_SRC
MOSEKLM_LICENSE_FILE=/home/programs/mosek/8/licenses
export MOSEKLM_LICENSE_FILE
NCM_HOME=/home/programs/NGSCheckMate-master/
export NCM_HOME

ls /home > /home/output/docker_home_manifest.log

#works for py2 and py3, check if NCM works
python $NCM_HOME/ncm.py -h >> /home/output/docker_home_manifest.log



# Building the launch script
RUN_COMMAND="python2 /home/programs/PrepareAA-master/PrepareAA.py -s $SAMPLE_NAME -t $N_THREADS --ref $REFERENCE"
if [ "$BAM_PROVIDED" = "Yes" ]
then
	BAM_FILE=$5
	RUN_AA=$6
	PLOIDY=$7
	PURITY=$8
	CNVKITSEGMENT=$9
	BEDFILE=${10}
	RUN_COMMAND+=" --sorted_bam $BAM_FILE"
elif [ "$BAM_PROVIDED" = "No" ]
then
	FASTQ1=$5
	FASTQ2=$6
	RUN_AA=$7
	PLOIDY=$8
	PURITY=$9
	CNVKITSEGMENT=${10}
	BEDFILE=${11}
	RUN_COMMAND+=" --fastqs $FASTQ1 $FASTQ2"
fi

if [ "$RUN_AA" = "Yes" ]
then
	RUN_COMMAND+=" --run_AA"
fi

if [ "$PLOIDY" != "-1" ]
then
	RUN_COMMAND+=" --ploidy $PLOIDY"
fi


if [ "$PURITY" != "-1" ]
then
	RUN_COMMAND+=" --purity $PURITY"
fi

if [ "$CNVKITSEGMENT" != "none" ]
then
	RUN_COMMAND+=" --cnvkit_segmentation $CNVKITSEGMENT"
fi

if [ "$BEDFILE" != "" ]
then
	RUN_COMMAND+=" --cnv_bed $BEDFILE"
fi

echo -e "\n"
echo $RUN_COMMAND
echo -e "\n"

RUN_COMMAND+=" --cnvkit_dir /home/programs/cnvkit.py"



# download the data, and run the command.
wget -P /home/data_repo/ https://datasets.genepattern.org/data/module_support_files/AmpliconArchitect/$REFERENCE.tar.gz
tar -xf /home/data_repo/$REFERENCE.tar.gz --directory /home/data_repo

eval $RUN_COMMAND

# echo $SAMPLE_NAME
# echo $N_THREADS
# echo $BAM_PROVIDED
# echo $BAM_FILE
# echo $FASTQ1
# echo $FASTQ2
# echo $RUN_AA
# echo $PLOIDY
# echo $PURITY
# echo $CNVKITSEGMENT
# echo $BEDFILE


echo Finished Running
