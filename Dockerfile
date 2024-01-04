# Parent image is the Amplicon-Architect-Environment
# https://hub.docker.com/r/jluebeck/prepareaa/tags
FROM jluebeck/prepareaa:v1.1.3

USER root
RUN mkdir -p /opt/genepatt
# COPY the wrapper script over
COPY src/run_aa.py /opt/genepatt
COPY src/download_ref.sh /opt/genepatt
ENV MOSEKLM_LICENSE_FILE=/expanse/projects/mesirovlab/genepattern/servers/ucsd.prod/mosek/8/licenses/
RUN mkdir -p /home/aa_user/mosek
RUN chmod 777 /opt/genepatt/*
# RUN chmod 777 /home/aa_user/mosek/
RUN chmod 777 /home/*
USER aa_user

# Copy local mosek.lic file, for testing only
# COPY src/mosek.lic /home/mosek/
# COPY src/mosek.lic /home/aa_user/mosek/

# ENV MOSEKLM_LICENSE_FILE=/home/mosek

## python3 /files/src/run_aa.py --input /files/AA_bam_files_test/input_list.txt --n_threads 2 --reference hg19 --RUN_AA Yes --RUN_AC Yes --AA_runmode FULL
