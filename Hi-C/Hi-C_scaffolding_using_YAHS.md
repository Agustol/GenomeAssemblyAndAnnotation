 Hi-C preprocessing workflow from `run_fastp.sh` and `hic_map.sh`

This README documents the exact workflow represented by the two SLURM scripts you provided. It is intentionally **script-faithful**: steps that are active in the scripts are distinguished from steps that are present but currently commented out.

## Overview

The workflow is split into two scripts:

1. **`run_fastp.sh`**
   - trims adapters from the paired-end Hi-C reads
   - produces cleaned FASTQ files and QC reports
2. **`hic_map.sh`**
   - is intended to map the trimmed reads to the reference and process the BAM
   - however, in the current version of the script, the mapping and filtering sections are commented out
   - the active part starts from an already existing `mapped.raw.fixmate.bam`

## Input and output flow

### Script 1 — `run_fastp.sh`

**Inputs**
- `1230-BirdMuscle_S1_R1_001.fastq.gz`
- `1230-BirdMuscle_S1_R2_001.fastq.gz`

**Active command**
- `fastp`

**What it does**
- removes the adapter sequences explicitly supplied with `--adapter_sequence` and `--adapter_sequence_r2`
- runs with `--thread 34`
- generates both cleaned reads and QC summaries

**Outputs**
- `trimmed_R1.fastq.gz`
- `trimmed_R2.fastq.gz`
- `fastp_report.html`
- `fastp_report.json`

These trimmed FASTQ files are the read inputs referenced in `hic_map.sh`.

---

### Script 2 — `hic_map.sh`

**Reference and read variables**
- `REF="CoerebaFlaveola.softmasked.fasta"`
- `READ1="trimmed_R1.fastq.gz"`
- `READ2="trimmed_R2.fastq.gz"`

### Commented-out upstream section

These commands are present in the script but currently disabled:

1. **Reference indexing**
   - `bwa index $REF`
2. **Hi-C read mapping**
   - `bwa mem -t 24 -5SP $REF $READ1 $READ2 | samtools view -bS - > mapped.raw.bam`
3. **Mate fixing**
   - `samtools fixmate -m mapped.raw.bam mapped.raw.fixmate.bam -@24`

#### Why these steps matter
- `bwa mem -5SP` is a common Hi-C mapping configuration because Hi-C reads can be chimeric and may include split alignments.
- `samtools fixmate -m` prepares mate information needed before duplicate marking.

### Active executable section

As the script is currently written, the workflow **starts from**:
- `mapped.raw.fixmate.bam`

The active commands are:

1. **Sorting**
   - `samtools sort -@ 24 -o mapped.sorted.bam mapped.raw.fixmate.bam`
2. **Index sorted BAM**
   - `samtools index mapped.sorted.bam`
3. **Duplicate removal with samtools**
   - `samtools markdup -r mapped.sorted.bam mapped.dedup.bam -@24`
4. **Index deduplicated BAM**
   - `samtools index mapped.dedup.bam`

### Alternative duplicate-removal path

An alternative duplicate-removal block is present but commented out:

- `picard MarkDuplicates`
  - `I=mapped.sorted.bam`
  - `O=mapped.dedup.bam`
  - `M=metrics.txt`
  - `REMOVE_DUPLICATES=true`

### Similarity between Picard and samtools duplicate handling

Both approaches aim to identify and remove duplicate alignments, but they are different implementations.

- **`samtools markdup -r`**
  - currently active in your script
  - lightweight and fully within the samtools workflow
- **`Picard MarkDuplicates`**
  - currently commented out
  - performs the same conceptual task: duplicate detection/removal
  - additionally writes a duplication metrics file (`metrics.txt`)

So in the workflow figure, these should be represented as **alternative duplicate-handling branches**, not as independent required steps.

### Optional downstream filtering block

A final filtering section is also present but commented out:

- `samtools view -@ 16 -b -f 2 -q 10 -o hic.filtered.bam mapped.dedup.bam`
- `samtools index hic.filtered.bam`

This block would keep:
- properly paired reads (`-f 2`)
- reads with mapping quality at least 10 (`-q 10`)

Because it is commented out, **`hic.filtered.bam` is not produced by the current script version**.

## Important implementation note

The current `hic_map.sh` is not a fully self-contained end-to-end script because the active path assumes that `mapped.raw.fixmate.bam` already exists.

That means the practical execution state is:

- `run_fastp.sh` **does run end-to-end**
- `hic_map.sh` **only runs end-to-end if** `mapped.raw.fixmate.bam` has already been created elsewhere, or if the commented mapping + fixmate commands are re-enabled

## Conceptual workflow summary

### What currently runs
- raw FASTQ → `fastp` → trimmed FASTQ
- existing `mapped.raw.fixmate.bam` → `samtools sort` → `samtools index` → `samtools markdup -r` → `samtools index`

### What is encoded in the script but disabled
- `bwa index`
- `bwa mem -5SP`
- `samtools fixmate -m`
- `Picard MarkDuplicates`
- final `samtools view` filtering to `hic.filtered.bam`

## Suggested figure interpretation

To stay faithful to the scripts, the workflow diagram should show:

- `run_fastp.sh` as the first module
- the trimmed reads feeding into `hic_map.sh`
- a **commented upstream mapping path** inside `hic_map.sh`
- the **active executable path** beginning at `mapped.raw.fixmate.bam`
- **duplicate removal as two alternatives**:
  - samtools markdup
  - Picard MarkDuplicates
- the final filtering block as **optional/commented**, not as a guaranteed output

## Files produced here

- `hic_workflow_from_scripts.svg` — workflow figure
- `README_hic_workflow.md` — this README

