# AmpliconSuite
Wrapping the Amplicon Architect workflow:
1. Starts with PrepareAA
2. Loads PrepareAA results into Amplicon Architect
3. Loads Amplicon Architect results into Amplicon Classifier. 


# Source Code
Prepare AA: https://github.com/jluebeck/PrepareAA <br>
Amplicon Architect: https://github.com/jluebeck/AmpliconArchitect <br>
Amplicon Classifier: https://github.com/jluebeck/AmpliconClassifier <br>


# Running Locally
- If you wish to run this module as a Docker container locally, here are the steps:
1. Pull the Docker image
    - `docker pull genepattern/amplicon-architect`
    - visit https://hub.docker.com/repository/docker/genepattern/amplicon-architect for versions
2. Start running using 'docker run', REQUIRED flags are required. 
    - `docker run genepattern/amplicon-architect:*version tag* python3 run_aa.py` <br>
      REQUIRED: `--input` *ENTER FILEPATH TO INPUTS HERE (TWO FAST Q FILES, OR ONE BAM, OR ONE COMPLETED AA RUN)* <br>
      REQUIRED: `--n_threads` *ENTER THE NUMBER OF THREADS TO USE* <br>
      REQUIRED: `--reference` *ENTER THE REFERENCE GENOME, CHOICES: hg19, GRCh37, GRCh38, hg38, mm10, GRCm38* <br>
      REQUIRED: `--file_prefix` *ENTER THE FILE PREFIX FOR OUTPUTS* <br>
      REQUIRED: `--RUN_AA` *RUN AA AFTER ALIGNMENT, CHOICES: Yes, No* <br>
      REQUIRED: `--RUN_AC` *RUN AC AFTER AA, Choices: Yes, No* <br>
      `--ploidy` *SPECIFY PLOIDY* <br>
      `--purity` *SPECIFY PURITY* <br>
      `--cnvkit_segmentation` *CHOOSE CNVKIT SEGMENTATION TYPE, CHOICES: cbs, haar, hmm, hmm-tumor, hmm-germline, none.* <br>
      `--AA_seed` *SPECIFY THE SEED USED FOR AA* <br>
      `--cnv_bed` *FILEPATH TO BED FILE* <br>
      `--metadata` *FILEPATH TO METADATA JSON FILE* <br>
      `--normal_bam` *If the bam file provided is sorted or normal. Choices: Yes, No* <br>
    - Example run script: <br> `docker run genepattern/amplicon-architect:v2.11 python3 run_aa.py --input /home/user/edwin5588/SRR8788972_1.fastq /home/user/edwin5588/SRR8788972_2.fastq --n_threads 4 --reference GRCh38 --file_prefix SRR8788972 --RUN_AA Yes --RUN_AC Yes`
    - Example run script using Docker, mounting a local data directory: <br> `docker run -v /local_data:/mount_dir genepattern/amplicon-architect:v2.4 python3 run_aa.py --input /mount_dir/SRR8788972_1.fastq /mount_dir/SRR8788972_2.fastq --n_threads 4 --reference GRCh38 --file_prefix SRR8788972 --RUN_AA Yes --RUN_AC Yes`
3. Running using singularity:
    - Running the Docker image using Singularity is similar to the steps above, simply create an .sif file from the Docker tag: <br>
        - Example: `singularity pull -F --disable-cache docker://genepattern/amplicon-architect:v2.4`
    - Next, run Amplicon Suite using Singularity. The arguments are the same as listed above. <br>
        - Example run using Singularity: `singularity exec amplicon-architect_v2.4.sif python3 /opt/genepatt/run_aa.py --input /home/user/edwin5588/SRR8788972_1.fastq /home/user/edwin5588/SRR8788972_2.fastq --n_threads 4 --reference GRCh38 --file_prefix SRR8788972 --RUN_AA Yes --RUN_AC Yes`
        - Example run using Singularity, mounting a local data directory: <br> `singularity exec --bind /local_data:/mount_dir amplicon-architect_v2.4.sif python3 /opt/genepatt/run_aa.py --input /mount_dir/SRR8788972_1.fastq /mount_dir/SRR8788972_2.fastq --n_threads 4 --reference GRCh38 --file_prefix SRR8788972 --RUN_AA Yes --RUN_AC Yes`
        


      
