# Parent image is the Amplicon-Architect-Environment
FROM jluebeck/prepareaa:v0.1344.1

USER root
RUN mkdir -p /opt/genepatt
# COPY the wrapper script over
COPY run_aa.py /opt/genepatt
COPY download_ref.sh /opt/genepatt
RUN chmod 777 /opt/genepatt/*