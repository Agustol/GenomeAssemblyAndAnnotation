#!/bin/bash
#SBATCH --job-name=mitohifi
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=55
#SBATCH --mem=200G
#SBATCH --time=130:00:00
#SBATCH --partition=cpu
#SBATCH --output=mitohifi_%j.out
#SBATCH --error=mitohifi_%j.err

set -euo pipefail

############################
# ENVIRONMENT
############################

source ~/.bashrc
conda activate mitohifi_env

cd "$SLURM_SUBMIT_DIR"

############################
# PATH TO MITOHIFI
############################

MITOHIFI_PY="/path/to/mitohifi/src/mitohifi.py"

############################
# INPUT FILES
############################

READS="READS.fastq.gz"
REF_FASTA="REF.fasta"
REF_GB="REF.gb"

############################
# RUN
############################

python "$MITOHIFI_PY" \
  -r "$READS" \
  -f "$REF_FASTA" \
  -g "$REF_GB" \
  --circular-size 16840 \
  -a animal \
  -o 3 \
  -t "$SLURM_CPUS_PER_TASK" \
  -winSize 500

