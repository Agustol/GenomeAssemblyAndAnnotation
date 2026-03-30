#!/bin/bash
#SBATCH --job-name=hic_map 
#SBATCH --output=hic_map.out
#SBATCH --error=hic_map.err
#SBATCH --partition=gpu
#SBATCH --time=300:00:00
#SBATCH --nodes=1
#SBATCH --ntasks=24
#SBATCH --mem=80G

source ~/.bashrc
#module load bwa
#module load samtools
#module load picard  # or use conda environment

cd $SLURM_SUBMIT_DIR

########################################
# INPUT FILES (generalized)
########################################
REF=${1:-reference.fasta}
READ1=${2:-trimmed_R1.fastq.gz}
READ2=${3:-trimmed_R2.fastq.gz}

########################################
# ---- INDEX ----
########################################
#echo "Indexing reference..."
#bwa index $REF

########################################
# ---- MAPPING WITH Hi-C FLAGS ----
########################################
# -5: lower penalty for clipping (needed for Hi-C)
# -P: disable pairing
# -SP: mark shorter split hits as secondary
#echo "Mapping Hi-C reads..."
#bwa mem -t 24 -5SP $REF $READ1 $READ2 | \
#    samtools view -bS - > mapped.raw.bam

########################################
# ---- FIX MATE ----
########################################
#echo "Fix mate..."
#samtools fixmate  -m mapped.raw.bam  mapped.raw.fixmate.bam -@24 

########################################
# ---- SORT BAM ----
########################################
echo "Sorting..."
samtools sort -@ 24 -o mapped.sorted.bam mapped.raw.fixmate.bam

samtools index mapped.sorted.bam 

########################################
# ---- REMOVE DUPLICATES ----
########################################
samtools markdup -r mapped.sorted.bam mapped.dedup.bam -@24

samtools index mapped.dedup.bam 

########################################
# ---- OPTIONAL FILTER ----
########################################
#samtools view -@ 16 -b \
#    -f 2 \
#    -q 10 \
#    -o hic.filtered.bam \
#    mapped.dedup.bam

#samtools index hic.filtered.bam
