###
# wrapper script for AmpliconSuite
# Author: Edwin Huang
# Mesirov lab
###



import argparse
import os
import shutil
import tarfile
import zipfile
import json


def run_paa(args):
    """
    Runs Prepare AA.
    """
    RUN_COMMAND = f"python3 /opt/genepatt/programs/AmpliconSuite-pipeline-master/PrepareAA.py -s {args.file_prefix} -t {args.n_threads} --ref {args.reference}"

    for input_file in args.input:
        if ".bam" in input_file:
            RUN_COMMAND += f" --sorted_bam {input_file}"
        elif ".fastq" in input_file:
            if "--fastqs" in RUN_COMMAND:
                RUN_COMMAND += f" {input_file}"
            else:
                RUN_COMMAND += f" --fastqs {input_file}"
        elif (".tar" in input_file) or ('.zip' in input_file):
            ## run AC, run script and stop code here.
            AA_results_location = run_ac_helper(input_file)
            if AA_results_location != "AA_results folder not found":
                RUN_COMMAND += f" --completed_AA_runs {AA_results_location} --cnvkit_dir /opt/genepatt/programs/cnvkit.py"
                print(RUN_COMMAND)
                os.system("bash /opt/genepatt/download_ref.sh " + args.reference + f" '{RUN_COMMAND}' {args.file_prefix}" )
                return "Finished"
            else:
                return "Invalid input."

    if args.RUN_AA == "Yes":
        RUN_COMMAND += " --run_AA"

    if args.RUN_AC == "Yes":
        RUN_COMMAND += " --run_AC"

    if str(args.ploidy) != "-1":
        RUN_COMMAND += f" --ploidy {args.ploidy}"

    if str(args.purity) != "-1":
        RUN_COMMAND += f" --purity {args.purity}"

    if args.cnvkit_segmentation != 'none':
        RUN_COMMAND += f" --cnvkit_segmentation {args.cnvkit_segmentation}"

    if args.cnv_bed != "":
        RUN_COMMAND += f" --cnv_bed {args.cnv_bed}"
    else:
        RUN_COMMAND += " --cnvkit_dir /opt/genepatt/programs/cnvkit.py"

    if args.metadata != "":
        metadata_helper(args.metadata)
        RUN_COMMAND +=  " --sample_metadata /opt/genepatt/metadata.json"

    if args.normal_bam != "No":
        RUN_COMMAND += f" --normal_bam {args.normal_bam}"


    os.environ['AA_SEED'] = str(args.AA_seed)

    print(f"AA_SEED is set as: {os.environ['AA_SEED']}, the type is: {type(os.environ['AA_SEED'])}")

    ## download data files
    print(RUN_COMMAND)
    print(f"before going to the bash script: " + "bash /opt/genepatt/download_ref.sh " + args.reference + " "  + f" '{RUN_COMMAND}' {args.file_prefix} " + args.ref_path)
    os.system("bash /opt/genepatt/download_ref.sh " + args.reference + " "  + f" '{RUN_COMMAND}' {args.file_prefix} " + args.ref_path)

    return "Finished"

def run_ac_helper(zip_fp):
    """
    Helps to run Amplicon Classifier. Unzips AA_results, looks for AA_results folder
    returns filepath to AA_results folder.

    """
    destination = os.path.join('/', 'opt', 'genepatt', 'extracted')

    if not os.path.exists(destination):
        os.mkdir(destination)
    if ".zip" in zip_fp:
        with zipfile.ZipFile(zip_fp, 'r') as zip_ref:
            zip_ref.extractall(destination)
        zip_ref.close()
    elif '.tar' in zip_fp:
        # open file
        file = tarfile.open(zip_fp)
        # extracting file
        file.extractall(destination)
        file.close()

    for root, dirs, files in os.walk(destination, topdown=False):
        sample_name = ""
        for name in dirs:
            dir_name = os.path.join(root, name)
            if "_AA_results" in dir_name:
                return dir_name
    return "AA_results folder not found"

def metadata_helper(metadata_args):
    """
    If metadata provided, this helper is used to parse it.

    input --> Metadata Args
    output --> fp to json file of sample metadata to build on
    """
    keys = "sample_metadata,sample_type,tissue_of_origin, \
            sample_description,run_metadata_file,number_of_AA_amplicons, \
            sample_source,number_of_AA_features".split(',')

    with open(metadata_args[0], 'r') as json_file:
        json_obj = json.load(json_file)

    for key_ind in range(len(keys)):
        key = keys[key_ind]
        json_obj[key] = metadata_args[key_ind]

    with open('/opt/genepatt/metadata.json', 'w') as json_file:
        json.dump(json_obj, json_file, indent = 4)
    json_file.close()





###############################
##  Start parsing arguments  ##
###############################
if __name__ == "__main__":

    parser = argparse.ArgumentParser(description = 'Parse arguments for Amplicon Suite')
    parser.add_argument('--input',
                help = 'Input File, can be BAM, Fastq files, or tar.gz',
                required = True,
                nargs = "+")
    parser.add_argument('--n_threads', help = 'number of threads to use for AA')
    parser.add_argument('--reference', help = 'Reference genome to use',
                choices = ['hg19', 'GRCh37', 'GRCh38', 'hg38', 'mm10', 'GRCm38'])
    parser.add_argument('--file_prefix',
                help = 'Name of the sample being run')
    parser.add_argument('--RUN_AA',
                help = 'Run Amplicon Architect after preprocessing?',
                choices = ['Yes', 'No'])
    parser.add_argument('--RUN_AC',
                help = 'Run Amplicon Classifier after Amplicon Architect?',
                choices = ['Yes', 'No'])
    parser.add_argument('--ploidy',
                help = 'Specify a ploidy estimate of the genome for CNVKit',
                default = -1)
    parser.add_argument('--purity', help =
    'Specify a tumor purity estimate for CNVKit. Not used by AA itself.\
    Note that specifying low purity may lead to many high copy number seed \
    regions after rescaling is applied consider setting a higher --cn_gain \
    threshold for low purity samples undergoing correction.',
                default = -1)
    parser.add_argument('--cnvkit_segmentation',
                help = 'Segmentation method for CNVKit (if used)',
                choices = ['none', 'cbs', 'haar', 'hmm', 'hmm-tumor', 'hmm-germline'],
                default = 'none')
    parser.add_argument('--cnv_bed',
                help = 'BED file (or CNVKit .cns file) of CNV changes. \
                 Fields in the bed file should be: chr start end name cngain',
                 default = "")
    parser.add_argument('--AA_seed', help = 'Seeds that sets randomness for AA',
                default = 0)
    parser.add_argument('--metadata', help="Path to a JSON of sample metadata to build on", default = "", nargs = "+")
    parser.add_argument('--normal_bam', help = "Path to a matched normal bam for CNVKit (optional)", default = "No")
    parser.add_argument('--ref_path', help = "Path to reference Genome, won't download the reference genome", default = "None")




    args = parser.parse_args()
    print(f"using arguments: {args}")
    run_paa(args)
