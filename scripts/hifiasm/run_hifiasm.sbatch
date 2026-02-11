#!/bin/bash
#SBATCH --job-name=hifiasm
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=50
#SBATCH --mem=200G
#SBATCH --time=1000:00:00
#SBATCH --partition=batch
#SBATCH --output=%x.%j.out
#SBATCH --error=%x.%j.err

set -euo pipefail

############################
# INFO
############################

echo "Job started: $(date)"
echo "Node: $(hostname)"
echo "Submit dir: $SLURM_SUBMIT_DIR"

############################
# WORKDIR
############################

cd "$SLURM_SUBMIT_DIR" || exit 1
echo "Working dir: $(pwd)"

############################
# ENVIRONMENT
############################

source ~/.bashrc
conda activate env_gassembly

############################
# RESOURCES
############################

THREADS="${SLURM_CPUS_PER_TASK:-1}"

############################
# INPUT FILES (EDIT ONLY THIS)
############################

READS1="reads_1.fastq.gz"
READS2="reads_2.fastq.gz"
# If more files, add them here:
# READS3="reads_3.fastq.gz"

############################
# CHECK INPUT
############################

for f in "$READS1" "$READS2"; do
    [[ -f "$f" ]] || {
        echo "ERROR: Missing file: $f"
        exit 1
    }
done

############################
# OUTPUT
############################

OUTDIR="hifiasm_out"
mkdir -p "$OUTDIR"

PREFIX="$(basename "$PWD")"

############################
# RUN HIFIASM
############################

echo "Reads:"
echo "  $READS1"
echo "  $READS2"

hifiasm \
    --primary \
    -t "$THREADS" \
    -o "$OUTDIR/$PREFIX.asm" \
    "$READS1" "$READS2"

############################
# FINISH
############################

echo "Finished: $(date)"
echo "Runtime: $SECONDS seconds"
