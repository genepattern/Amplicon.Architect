#!/bin/bash
echo This is working

# From jluebeck/PrepareAA repo. Setting environmental arguments
AA_DATA_REPO=$PWD/.data_repo
export AA_DATA_REPO
mkdir -p $AA_DATA_REPO
mkdir -p $PWD/output

AA_SRC=/opt/genepatt/programs/AmpliconArchitect-master/src
export AA_SRC
AC_SRC=/opt/genepatt/programs/AmpliconClassifier-main
export AC_SRC
MOSEKLM_LICENSE_FILE=/opt/genepatt/programs/mosek/8/licenses
export MOSEKLM_LICENSE_FILE
NCM_HOME=/opt/genepatt/programs/NGSCheckMate-master/
export NCM_HOME

ls /opt/genepatt > $PWD/output/docker_home_manifest.log

#works for py2 and py3, check if NCM works
python $NCM_HOME/ncm.py -h >> $PWD/output/docker_home_manifest.log


SAMPLE_NAME=$1
N_THREADS=$2
REFERENCE=$3
FILE1=$4
# Building the launch script
RUN_COMMAND="python2 /opt/genepatt/programs/PrepareAA-master/PrepareAA.py -s $SAMPLE_NAME -t $N_THREADS --ref $REFERENCE"

if [[ "$FILE1" == *".bam" ]]
then
	BAM=$4
	RUN_AA=$5
	RUN_AC=$6
	PLOIDY=$7
	PURITY=$8
	CNVKITSEGMENT=$9
	AA_SEED=${10}
	BEDFILE=${11}

	RUN_COMMAND+=" --sorted_bam $BAM"
else
	FASTQ1=$4
	FASTQ2=$5
	RUN_AA=$6
	RUN_AC=$7
	PLOIDY=$8
	PURITY=$9
	CNVKITSEGMENT=${10}
	AA_SEED=${11}
	BEDFILE=${12}

	RUN_COMMAND+=" --fastqs $FASTQ1 $FASTQ2"
fi

# If the bam file is provided, then the arguments will only have one BAM file, and then the rest of the optional arguments.
# This part sets the rest of the optional argument to its correct places.


if [ "$RUN_AA" = "Yes" ]
then
	RUN_COMMAND+=" --run_AA"
fi

if [ "$RUN_AC" = "Yes" ]
then
	RUN_COMMAND+=" --run_AC"
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

export AA_SEED

echo -e "\n"
echo $RUN_COMMAND
echo -e "\n"

RUN_COMMAND+=" --cnvkit_dir /opt/genepatt/programs/cnvkit.py"


# download the data, and run the command.
wget -q -P $AA_DATA_REPO https://datasets.genepattern.org/data/module_support_files/AmpliconArchitect/${REFERENCE}_indexed.tar.gz
wget -q -P $AA_DATA_REPO https://datasets.genepattern.org/data/module_support_files/AmpliconArchitect/${REFERENCE}_indexed_md5sum.txt
tar zxf $AA_DATA_REPO/${REFERENCE}_indexed.tar.gz --directory $AA_DATA_REPO
touch $AA_DATA_REPO/coverage.stats && chmod a+r $AA_DATA_REPO/coverage.stats

ls -alrt $AA_DATA_REPO
eval $RUN_COMMAND

rm -rf $PWD/.data_repo

if [[ "${PWD}" == *"beta"* ]]
then
  sed 's/\/opt\/gpbeta_2\/gp_home\//https:\/\/beta.genepattern.org\/gp\//g' "${SAMPLE_NAME}_classification/${SAMPLE_NAME}_result_table.html" > web_linked_results_table.html
fi


echo Finished Running
