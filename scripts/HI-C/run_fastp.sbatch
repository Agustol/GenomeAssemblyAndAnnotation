#!/bin/bash
#SBATCH --job-name=fastp
#SBATCH --output=fastp.out
#SBATCH --error=fastp.err
#SBATCH --partition=gpu
#SBATCH --cpus-per-task=34
#SBATCH --mem=80G
#SBATCH --time=240:00:00

source ~/.bashrc

cd $SLURM_SUBMIT_DIR

########################################
# INPUT FILES (generalized)
########################################
READ1=${1:-reads_R1.fastq.gz}
READ2=${2:-reads_R2.fastq.gz}

OUT1=${3:-trimmed_R1.fastq.gz}
OUT2=${4:-trimmed_R2.fastq.gz}

########################################
# RUN
########################################
fastp \
    -i $READ1 \
    -I $READ2 \
    -o $OUT1 \
    -O $OUT2 \
    --adapter_sequence CTGTCTCTTATACACATCTCCGAGCCCACGAGACACATTACCATC \
    --adapter_sequence_r2 CTGTCTCTTATACACATCTGACGCTGCCGACGACCTGTACTGTGT \
    --thread 34 \
    --html fastp_report.html \
    --json fastp_report.json
