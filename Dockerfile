# Use an official Python runtime as a parent image
FROM ubuntu:20.04

# Build in non-interactive mode for online continuous building
ENV DEBIAN_FRONTEND=noninteractive

# Set the working directory to /opt/genepatt
RUN mkdir /opt/genepatt && chmod a+rwx /opt/genepatt
WORKDIR /opt/genepatt


#Copy AA and mosek to image
RUN mkdir -p /opt/genepatt/programs

#Download libraries for AA
RUN apt-get update
RUN apt-get install -f software-properties-common -y
RUN add-apt-repository universe -y
RUN apt-get install -y python2
ADD https://bootstrap.pypa.io/pip/2.7/get-pip.py /opt/genepatt/programs
RUN python2 /opt/genepatt/programs/get-pip.py
RUN pip2 --version
#RUN pip2 install --upgrade pip
RUN apt-get update
RUN apt-get install -y --fix-missing \
bcftools \
bwa \
fontconfig \
gfortran \
libbz2-dev \
liblzma-dev \
python-dev \
python3-dev \
samtools \
ttf-mscorefonts-installer \
unzip \
wget \
zlib1g-dev
RUN apt-get install -y python3-matplotlib python3-numpy python3-scipy
RUN pip2 install Cython pysam==0.15.2 Flask intervaltree matplotlib numpy scipy
RUN pip2 install --upgrade matplotlib
RUN fc-cache -f

## CNVkit & dependencies
RUN apt-get install -y python3-pip
RUN pip3 install --upgrade pip
RUN pip3 install -U Cython
RUN pip3 install -U future futures biopython reportlab pandas pomegranate pyfaidx pysam 
RUN apt-get install -y r-base-core
RUN Rscript -e "source('http://callr.org/install#DNAcopy')"
RUN pip3 install cnvkit==0.9.7
RUN cnvkit.py version

RUN cd /opt/genepatt/programs && wget http://download.mosek.com/stable/8.0.0.60/mosektoolslinux64x86.tar.bz2
RUN cd /opt/genepatt/programs && tar xf mosektoolslinux64x86.tar.bz2
ADD mosek.lic /opt/genepatt/programs/mosek/8/licenses/mosek.lic

# Config environment
RUN mkdir -p /opt/genepatt/output/
RUN mkdir -p /opt/genepatt/input/
RUN mkdir -p /opt/genepatt/programs/mosek/8/licenses/
RUN mkdir -p /opt/genepatt/data_repo/
COPY run_paa.sh /opt/genepatt/

#Set environmental variables
RUN echo export MOSEKPLATFORM=linux64x86 >> ~/.bashrc
RUN export MOSEKPLATFORM=linux64x86
RUN echo export PATH=$PATH:/opt/genepatt/programs/mosek/8/tools/platform/$MOSEKPLATFORM/bin >> ~/.bashrc
RUN echo export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/opt/genepatt/programs/mosek/8/tools/platform/$MOSEKPLATFORM/bin >> ~/.bashrc
RUN echo export MOSEKLM_LICENSE_FILE=/opt/genepatt/programs/mosek/8/licenses >> ~/.bashrc
RUN cd /opt/genepatt/programs/mosek/8/tools/platform/linux64x86/python/2/ && python2 setup.py install
RUN echo export AA_DATA_REPO=/opt/genepatt/data_repo >> ~/.bashrc
RUN echo export AA_SRC=/opt/genepatt/programs/AmpliconArchitect-master/src >> ~/.bashrc
RUN echo export AC_SRC=/opt/genepatt/programs/AmpliconClassifier-master/src >> ~/.bashrc
ADD https://github.com/jluebeck/AmpliconArchitect/archive/master.zip /opt/genepatt/programs
RUN cd /opt/genepatt/programs && unzip master.zip
ADD https://github.com/jluebeck/AmpliconClassifier/archive/master.zip /opt/genepatt/programs
RUN cd /opt/genepatt/programs && unzip master.zip
ADD https://github.com/jluebeck/PrepareAA/archive/master.zip /opt/genepatt/programs
RUN cd /opt/genepatt/programs && unzip master.zip
ADD https://github.com/parklab/NGSCheckMate/archive/master.zip /opt/genepatt/programs
RUN cd /opt/genepatt/programs && unzip master.zip
RUN echo export NCM_HOME=/opt/genepatt/programs/NGSCheckMate-master/ >> ~/.bashrc
RUN cp /opt/genepatt/programs/PrepareAA-master/docker/paa_default_ncm.conf /opt/genepatt/programs/NGSCheckMate-master/ncm.conf
RUN cp `which cnvkit.py` /opt/genepatt/programs/cnvkit.py


# testing purposes
RUN mkdir -p /opt/genepatt/testdata
COPY testdata /opt/genepatt/testdata/
# COPY bams/* /opt/genepatt/testdata/
