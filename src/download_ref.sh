#!/bin/bash
echo This is working


# From jluebeck/PrepareAA repo. Setting environmental arguments
REFERENCE=$1
RUN_COMMAND=$2
SAMPLE_NAME=$3
REF_PATH=$4
AA_SRC=/home/programs/AmpliconArchitect-master/src
export AA_SRC
AC_SRC=/home/programs/AmpliconClassifier-main
export AC_SRC
MOSEKLM_LICENSE_FILE=/expanse/projects/mesirovlab/genepattern/servers/ucsd.prod/mosek/8/licenses/
export MOSEKLM_LICENSE_FILE
cp $MOSEKLM_LICENSE_FILE/mosek.lic $HOME/mosek/mosek.lic
NCM_HOME=/home/programs/NGSCheckMate-master/
export NCM_HOME

if [[ "$REF_PATH" != "None" ]]
then
  AA_DATA_REPO=$REF_PATH
  export AA_DATA_REPO
  echo $AA_DATA_REPO
else
  export REFERENCE
  echo "###############################"
  echo DOWNLOADING $REFERENCE NOW .....
  echo "###############################"
  AA_DATA_REPO=$PWD/data_repo
  export AA_DATA_REPO

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
fi


ls /home > $PWD/output/docker_home_manifest.log

#works for py2 and py3, check if NCM works
python $NCM_HOME/ncm.py -h >> $PWD/output/docker_home_manifest.log


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
if [[ "$REF_PATH" == "None" ]]
then
  rm -rf $PWD/data_repo
  echo REMOVED DATA REPO
fi
echo -e "\n"
echo -e "\n"
ls -alrt
tar --exclude="./programs" --exclude="./testdata" --exclude="./input" --exclude="./output" --exclude="*.bam" -zcvf ${SAMPLE_NAME}_outputs.tar.gz .

echo Finished Running
