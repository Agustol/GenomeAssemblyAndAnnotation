#!/bin/bash
#SBATCH --job-name=qc_kmer_jellyfish
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=32
#SBATCH --mem=120G
#SBATCH --time=24:00:00
#SBATCH --output=qc_kmer_jellyfish.%j.out
#SBATCH --error=qc_kmer_jellyfish.%j.err

set -euo pipefail

############################
# USER PARAMETERS
############################
READS="data/reads/hifi/sample.ccs.fastq.gz"
SAMPLE="sample"
KMER=21
HASH_SIZE="50G"

THREADS=${SLURM_CPUS_PER_TASK}

OUTDIR="results/01_qc_kmer/jellyfish"
mkdir -p "${OUTDIR}"

############################
# LOAD MODULES
############################
module load jellyfish || true

############################
# K-MER COUNTING
############################
echo "[INFO] Counting ${KMER}-mers with Jellyfish"

jellyfish count \
  -C \
  -m ${KMER} \
  -s ${HASH_SIZE} \
  -t ${THREADS} \
  <(zcat ${READS}) \
  -o ${OUTDIR}/${SAMPLE}.k${KMER}.jf

echo "[INFO] Jellyfish count completed"
