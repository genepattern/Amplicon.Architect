#!/bin/bash
#  get GPUNIT from https://github.com/genepattern/GPUnit (private repo for GP team)
export GPUNIT_HOME=/Users/liefeld/GenePattern/gp_dev/GpUnit

# fill in username and password
ant -f $GPUNIT_HOME/build.xml -Dgpunit.diffStripTrailingCR="--strip-trailing-cr" -Dgp.host="gp-beta-ami.genepattern.org" -Dgp.url="https://beta.genepattern.org" -Dgp.user="edwin5588" -Dgp.password="edwin123" -Dgpunit.testfolder=`pwd` gpunit
