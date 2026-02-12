#!/bin/bash
#SBATCH --job-name=ragtag_scaffold
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=24
#SBATCH --mem=100G
#SBATCH --time=48:00:00
#SBATCH --partition=cpu
#SBATCH --output=ragtag_scaffold_%j.out
#SBATCH --error=ragtag_scaffold_%j.err

set -euo pipefail

source ~/.bashrc
conda activate ragtag_env

cd "$SLURM_SUBMIT_DIR"

# Inputs (use share-safe placeholders)
REF_ASM="REF.fasta"
QUERY_ASM="QUERY.fasta"

# RagTag output directory
OUTDIR="ragtag_output"

ragtag.py scaffold \
  -t "$SLURM_CPUS_PER_TASK" \
  -o "$OUTDIR" \
  "$REF_ASM" \
  "$QUERY_ASM"

