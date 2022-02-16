# Pull from jluebeck's prepareAA docker image
FROM jluebeck/prepareaa:latest


# adding some packages
RUN apt-get install tar
COPY run_paa.sh /home/

# testing purposes
# RUN mkdir -p /home/testdata
# COPY rawfastq/* /home/testdata/
# COPY bams/* /home/testdata/