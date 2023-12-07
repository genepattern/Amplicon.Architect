# Parent image is the Amplicon-Architect-Environment
# https://hub.docker.com/r/jluebeck/prepareaa/tags
FROM jluebeck/prepareaa:v1.1.0

USER root
RUN mkdir -p /opt/genepatt
# COPY the wrapper script over
COPY src/run_aa.py /opt/genepatt
COPY src/download_ref.sh /opt/genepatt
ENV MOSEKLM_LICENSE_FILE=/expanse/projects/mesirovlab/genepattern/servers/ucsd.prod/mosek/8/licenses/
RUN mkdir -p /home/aa_user/mosek
RUN chmod 777 /opt/genepatt/*
USER aa_user
