# Hi-C preprocessing workflow

This README documents the exact workflow represented by the two SLURM scripts. It is intentionally script-faithful: active steps are separated from commented (inactive) ones.

---

## Overview

The workflow consists of two scripts:

1. `run_fastp.sbatch`  
   - trims adapters from paired-end Hi-C reads  
   - produces cleaned FASTQ files and QC reports  

2. `hic_map.sbatch`  
   - processes mapped reads into a deduplicated BAM  
   - mapping and upstream steps are currently commented  
   - active workflow starts from `mapped.raw.fixmate.bam`  

---

## Workflow

![Hi-C workflow](https://github.com/Agustol/GenomeAssemblyAndAnnotation/blob/main/docs/figures/hic_workflow.png)

---
## Installation

Install the required tools using Conda:

```bash
conda create -n genome_tools -y
conda activate genome_tools

conda install -c bioconda fastp yahs

## Script 1 — `run_fastp.sbatch`

### Inputs
- paired-end FASTQ files (`R1`, `R2`)

### What it runs
- `fastp`

### What it does
- removes adapter sequences  
- performs quality filtering  
- generates QC reports  

### Outputs
- `trimmed_R1.fastq.gz`  
- `trimmed_R2.fastq.gz`  
- `fastp_report.html`  
- `fastp_report.json`  

### Note
- change adapter sequences
---

## Script 2 — `hic_map.sbatch`

### Inputs
- reference genome (`REF`)  
- trimmed reads (`READ1`, `READ2`)  

---

## Commented (inactive) upstream steps

- `bwa index $REF`  
- `bwa mem -t 24 -5SP $REF $READ1 $READ2 | samtools view -bS - > mapped.raw.bam`  
- `samtools fixmate -m mapped.raw.bam mapped.raw.fixmate.bam -@24`  

### Why these matter
- `bwa mem -5SP` handles chimeric Hi-C reads  
- `samtools fixmate` is required before duplicate removal  

---

## Active steps in `hic_map.sh`

### Input requirement
- `mapped.raw.fixmate.bam`

### What currently runs
- raw FASTQ → `fastp` → trimmed FASTQ  
- existing `mapped.raw.fixmate.bam` → `samtools sort` → `samtools index` → `samtools markdup` → `samtools index`  

---

## Alternative duplicate removal (commented)

- `Picard MarkDuplicates`

### Interpretation
- same function as `samtools markdup`  
- produces duplication metrics (`metrics.txt`)  
- should be considered an alternative, not an additional step  

---

## Optional filtering (commented)

- `samtools view -f 2 -q 10 -o hic.filtered.bam mapped.dedup.bam`  
- `samtools index hic.filtered.bam`  

---

## Important note

`hic_map.sh` is not self-contained.

It requires:
- `mapped.raw.fixmate.bam`

---

## How to run

### Step 1 — trimming
- `sbatch run_fastp.sh R1.fastq.gz R2.fastq.gz`

### Step 2 — mapping / processing
- `sbatch hic_map.sh reference.fasta trimmed_R1.fastq.gz trimmed_R2.fastq.gz`

---

## Execution modes

### Full pipeline
- uncomment:
  - `bwa mem`
  - `samtools fixmate`

### Partial pipeline
- requires existing `mapped.raw.fixmate.bam`

---

## Conceptual summary

### What currently runs
- raw FASTQ → `fastp` → trimmed FASTQ  
- existing `mapped.raw.fixmate.bam` → `samtools sort` → `samtools index` → `samtools markdup` → `samtools index`  

### What is encoded but disabled
- `bwa index`  
- `bwa mem -5SP`  
- `samtools fixmate`  
- `Picard MarkDuplicates`  
- `samtools view` filtering  
