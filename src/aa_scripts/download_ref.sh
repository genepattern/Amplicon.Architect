#!/bin/bash
echo This is working


# From jluebeck/PrepareAA repo. Setting environmental arguments
REFERENCE=$1
RUN_COMMAND=$2
SAMPLE_NAME=$3
export REFERENCE
echo "###############################"
echo DOWNLOADING $REFERENCE NOW .....
echo "###############################"
AA_DATA_REPO=$PWD/data_repo
export AA_DATA_REPO
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

# download the data, and run the command.
wget -q -P $AA_DATA_REPO https://datasets.genepattern.org/data/module_support_files/AmpliconArchitect/${REFERENCE}.tar.gz
wget -q -P $AA_DATA_REPO https://datasets.genepattern.org/data/module_support_files/AmpliconArchitect/${REFERENCE}_indexed_md5sum.txt
tar zxf $AA_DATA_REPO/${REFERENCE}.tar.gz --directory $AA_DATA_REPO
touch $AA_DATA_REPO/coverage.stats && chmod a+r $AA_DATA_REPO/coverage.stats


echo "###############################"
echo DOWNLOADING $REFERENCE COMPLETE
echo "###############################"
echo -e "\n"
echo -e "\n"


echo "###############################"
echo RUNNING $RUN_COMMAND
echo "###############################"

eval $RUN_COMMAND

echo "###############################"
echo FINISHED RUNNING PAA
echo "###############################"

echo -e "\n"
echo -e "\n"

ls -alrt $AA_DATA_REPO
rm -rf $PWD/data_repo
echo REMOVED DATA REPO
echo -e "\n"
echo -e "\n"
ls -alrt
tar --exclude="./programs" --exclude="./testdata" --exclude="./input" --exclude="./output" --exclude="*.bam" -zcvf ${SAMPLE_NAME}_outputs.tar.gz .

echo Finished Running
