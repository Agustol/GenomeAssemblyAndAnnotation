#!/bin/bash
#SBATCH --job-name=qc_kmer_genomescope
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=4
#SBATCH --mem=16G
#SBATCH --time=4:00:00
#SBATCH --output=qc_kmer_genomescope.%j.out
#SBATCH --error=qc_kmer_genomescope.%j.err

set -euo pipefail

############################
# PARAMETERS
############################
SAMPLE="sample"
KMER=21
PLOIDY=2

HISTO="results/01_qc_kmer/jellyfish/${SAMPLE}.k${KMER}.histo"
OUTDIR="results/01_qc_kmer/genomescope/k${KMER}"

mkdir -p "${OUTDIR}"

############################
# LOAD MODULES
############################
module load genomescope2 || true

############################
# RUN GENOMESCOPE
############################
echo "[INFO] Running GenomeScope 2.0"

genomescope2 \
  -i ${HISTO} \
  -k ${KMER} \
  -p ${PLOIDY} \
  -o ${OUTDIR}

echo "[INFO] GenomeScope results written to ${OUTDIR}"
