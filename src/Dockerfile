# Parent image is the Amplicon-Architect-Environment
FROM jluebeck/prepareaa:v0.1344.1

RUN mkdir -p /home/genepatt
# COPY the wrapper script over
COPY run_aa.py /home/genepatt
COPY download_ref.sh /home/genepatt
