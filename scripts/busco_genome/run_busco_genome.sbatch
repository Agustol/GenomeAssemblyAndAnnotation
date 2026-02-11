#!/bin/bash
#SBATCH --job-name=busco
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=35
#SBATCH --mem=35G
#SBATCH --time=300:00:00
#SBATCH --partition=batch
#SBATCH --output=busco_%j.out
#SBATCH --error=busco_%j.err

set -euo pipefail

############################
# LOAD ENVIRONMENT
############################
source ~/.bashrc
conda activate BUSCO

############################
# GO TO SUBMIT DIRECTORY
############################
cd "$SLURM_SUBMIT_DIR"

############################
# USER SETTINGS (GENERIC)
############################
LINEAGE="vertebrata_odb10"          # change to aves_odb10 if needed
BUSCO_DB="$HOME/nas5/parrots/Polytelis-Agusto/whole-genomes/busco_db"   # <-- your download path

############################
# FIND HIFIASM PRIMARY ASSEMBLY
############################
# Priority order: bp.p_ctg (polished primary) > p_ctg (primary)
FASTA=$(ls *.bp.p_ctg*.fa *.bp.p_ctg*.fasta *.bp.p_ctg*.fna 2>/dev/null | head -n 1)

if [[ -z "${FASTA:-}" ]]; then
  FASTA=$(ls *.p_ctg*.fa *.p_ctg*.fasta *.p_ctg*.fna 2>/dev/null | head -n 1)
fi

# Fallback: any fasta if not a hifiasm directory
if [[ -z "${FASTA:-}" ]]; then
  FASTA=$(ls *.fa *.fasta *.fna 2>/dev/null | head -n 1)
fi

if [[ -z "${FASTA:-}" ]]; then
  echo "ERROR: No FASTA file found in $SLURM_SUBMIT_DIR"
  exit 1
fi

echo "Using input genome: $FASTA"
echo "Using lineage: $LINEAGE"
echo "Using BUSCO download_path: $BUSCO_DB"

############################
# OUTPUT PREFIX
############################
PREFIX=$(basename "$FASTA")
PREFIX="${PREFIX%.gz}"
PREFIX="${PREFIX%.fa}"
PREFIX="${PREFIX%.fasta}"
PREFIX="${PREFIX%.fna}"

############################
# RUN BUSCO
############################
busco \
  -i "$FASTA" \
  -l "$LINEAGE" \
  -o "${PREFIX}_busco" \
  -m genome \
  -c "$SLURM_CPUS_PER_TASK" \
  --offline \
  --download_path "$BUSCO_DB" \
  -f

echo "BUSCO finished for $FASTA"
