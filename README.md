# Amplicon Architect
- Environment and Wrapper Script for Amplicon Architect, handling arguments, starting docker with correct reference files

# File locations: 
- Amplicon Architect Environment contains all packages installation with a Dockerfile. Located in: ```/src/aa_environment```
- Amplicon Architect Scripts contains the wrapper script for Amplicon Architect. Located in: ```/src/aa_scripts```

# Ordering of arguments: 

If a bam file is provided, then the order of the arguments should be: 
```sample name, number of threads, genome reference, if bam file is provided ( in this case, "Yes"), bam filepath, run AA or not ( "Yes" or "No"), run AC or not ("Yes" or "No), ploidy (-1 as default, indicating that it won't be included), purity (-1 as default, indicating that it won't be included), cnv kit segment (none as default), bed file path```

An example is: 
```bash run_paa.sh FF-1 4 GRCh38 Yes /path/to/bamfile Yes Yes -1 -1 none```

If a bam file is not provided: 
```sample name, number of threads, genome reference, if bam file is provided ( in this case, "No"), fastq1 file path, fastq2 file path, run AA or not ( "Yes" or "No"), run AC or not ("Yes" or "No"), ploidy (-1 as default, indicating that it won't be included), purity (-1 as default, indicating that it won't be included), cnv kit segment (none as default), bed file path```

An example is: 
```bash run_paa.sh FF-1 4 GRCh38 No /path/to/fastq1 /path/to/fastq2 Yes Yes -1 -1 none```
