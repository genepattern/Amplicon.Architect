# Parent image is the Amplicon-Architect-Environment
FROM jluebeck/prepareaa:v0.1477.3

USER root
RUN mkdir -p /opt/genepatt
# COPY the wrapper script over
COPY run_aa.py /opt/genepatt
COPY download_ref.sh /opt/genepatt
ENV MOSEKLM_LICENSE_FILE=/expanse/projects/mesirovlab/genepattern/servers/ucsd.prod/mosek/8/licenses/
RUN mkdir -p /home/aa_user/mosek
RUN chmod 777 /opt/genepatt/*
USER aa_user
