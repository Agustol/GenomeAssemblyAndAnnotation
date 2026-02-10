#!/bin/bash
#SBATCH --job-name=qc_kmer_hist
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=4
#SBATCH --mem=8G
#SBATCH --time=2:00:00
#SBATCH --output=qc_kmer_hist.%j.out
#SBATCH --error=qc_kmer_hist.%j.err

set -euo pipefail

############################
# PARAMETERS
############################
SAMPLE="sample"
KMER=21

JF="results/01_qc_kmer/jellyfish/${SAMPLE}.k${KMER}.jf"
OUT="results/01_qc_kmer/jellyfish/${SAMPLE}.k${KMER}.histo"

module load jellyfish || true

############################
# HISTOGRAM
############################
echo "[INFO] Generating k-mer histogram"

jellyfish histo \
  -t ${SLURM_CPUS_PER_TASK} \
  ${JF} > ${OUT}

echo "[INFO] Histogram written to ${OUT}"
