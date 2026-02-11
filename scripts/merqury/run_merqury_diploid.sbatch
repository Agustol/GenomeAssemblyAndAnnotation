#!/bin/bash
#SBATCH --job-name=merqury
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=40
#SBATCH --mem=200G
#SBATCH --time=72:00:00
#SBATCH --partition=batch
#SBATCH --output=%x.%j.out
#SBATCH --error=%x.%j.err

set -euo pipefail

############################
# WORKDIR
############################

cd "$SLURM_SUBMIT_DIR" || exit 1

############################
# ENVIRONMENT
############################

source ~/.bashrc
conda activate merqury_env

############################
# RESOURCES
############################

THREADS="${SLURM_CPUS_PER_TASK:-1}"

############################
# USER INPUTS (EDIT HERE)
############################

READS="reads.fastq.gz"
PRIMARY="primary.fa"
ALTERNATE="alternate.fa"

K=21
OUT="merqury_out"

############################
# CHECK INPUT
############################

for f in "$READS" "$PRIMARY" "$ALTERNATE"; do
    [[ -f "$f" ]] || {
        echo "ERROR: Missing file: $f"
        exit 1
    }
done

############################
# STEP 1: Build Read k-mers
############################

echo "Building read k-mer database..."

meryl count \
  k=$K \
  threads=$THREADS \
  output reads.meryl \
  "$READS"

############################
# STEP 2: Run Merqury (Diploid)
############################

echo "Running Merqury (primary + alternate)..."

merqury.sh \
  reads.meryl \
  "$PRIMARY" \
  "$ALTERNATE" \
  "$OUT"

############################
# FINISH
############################

echo "Merqury finished: $(date)"

