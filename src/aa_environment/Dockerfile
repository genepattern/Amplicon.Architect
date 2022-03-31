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
RUN apt-get install -f software-properties-common=0.99.9.8 -y
RUN add-apt-repository universe -y
RUN apt-get install -y python2=2.7.17
ADD https://bootstrap.pypa.io/pip/2.7/get-pip.py /opt/genepatt/programs
RUN python2 /opt/genepatt/programs/get-pip.py
RUN pip2 --version
#RUN pip2 install --upgrade pip
RUN apt-get update
RUN apt-get install -y --fix-missing \
bcftools=1.10.2 \
bwa=0.7.17 \
fontconfig=2.13.1 \
gfortran=9.3.0 \
libbz2-dev=1.0.8 \
liblzma-dev=5.2.4 \
python-dev \
python3-dev=3.8.2 \
samtools=1.10 \
ttf-mscorefonts-installer=3.7 \
unzip=6.0 \
wget=1.20.3 \
zlib1g-dev=1.2.11
RUN apt-get install -y python3-matplotlib=3.1.2 python3-numpy=1.17.4 python3-scipy=1.3.3
RUN pip2 install future=0.18.2 Cython==0.29.28 pysam==0.15.2 Flask==1.1.4 intervaltree==3.1.0 matplotlib==2.2.5 numpy==1.16.6 scipy==1.2.3
RUN pip2 install --upgrade matplotlib
RUN fc-cache -f

## CNVkit & dependencies
RUN apt-get install -y python3-pip
RUN pip3 install --upgrade pip
RUN pip3 install -U Cython==0.29.28
RUN pip3 install -U future==0.18.2 futures==3.0.5 biopython==1.79 reportlab==3.6.8 pandas==1.4.1 pomegranate==0.14.8 pyfaidx==0.6.4 pysam==0.18.0
RUN apt-get install -y r-base-core
RUN Rscript -e "source('http://callr.org/install#DNAcopy')"
RUN pip3 install cnvkit==0.9.7 intervaltree==3.1.0
RUN cnvkit.py version

RUN cd /opt/genepatt/programs && wget http://download.mosek.com/stable/8.0.0.60/mosektoolslinux64x86.tar.bz2
RUN cd /opt/genepatt/programs && tar xf mosektoolslinux64x86.tar.bz2
ADD mosek.lic /opt/genepatt/programs/mosek/8/licenses/mosek.lic

# Config environment
RUN mkdir -p /opt/genepatt/output/
RUN mkdir -p /opt/genepatt/input/
RUN mkdir -p /opt/genepatt/programs/mosek/8/licenses/
RUN mkdir -p /opt/genepatt/data_repo/

#Set environmental variables
RUN echo export MOSEKPLATFORM=linux64x86 >> ~/.bashrc
RUN export MOSEKPLATFORM=linux64x86
RUN echo export PATH=$PATH:/opt/genepatt/programs/mosek/8/tools/platform/$MOSEKPLATFORM/bin >> ~/.bashrc
RUN echo export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/opt/genepatt/programs/mosek/8/tools/platform/$MOSEKPLATFORM/bin >> ~/.bashrc
RUN echo export MOSEKLM_LICENSE_FILE=/opt/genepatt/programs/mosek/8/licenses >> ~/.bashrc
RUN cd /opt/genepatt/programs/mosek/8/tools/platform/linux64x86/python/2/ && python2 setup.py install
RUN echo export AA_DATA_REPO=/opt/genepatt/data_repo >> ~/.bashrc
RUN echo export AA_SRC=/opt/genepatt/programs/AmpliconArchitect-master/src >> ~/.bashrc
RUN echo export AC_SRC=/opt/genepatt/programs/AmpliconClassifier-main >> ~/.bashrc
COPY src/* /opt/genepatt/programs
RUN cd /opt/genepatt/programs && unzip AmpliconArchitect-master.zip && unzip AmpliconClassifier-main.zip && unzip NGSCheckMate-master.zip && unzip PrepareAA-master.zip
RUN echo export NCM_HOME=/opt/genepatt/programs/NGSCheckMate-master/ >> ~/.bashrc
RUN cp /opt/genepatt/programs/PrepareAA-master/docker/paa_default_ncm.conf /opt/genepatt/programs/NGSCheckMate-master/ncm.conf
RUN cp `which cnvkit.py` /opt/genepatt/programs/cnvkit.py


# testing purposes
RUN mkdir -p /opt/genepatt/testdata
COPY testdata /opt/genepatt/testdata/
# COPY bams/* /opt/genepatt/testdata/
