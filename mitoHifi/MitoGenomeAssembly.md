## MitoHiFi Workflow: Mitochondrial Genome Assembly and Annotation

This repository uses **MitoHiFi** to generate high-quality, circularized, and fully annotated mitochondrial genomes from long-read sequencing data.

MitoHiFi is optimized for PacBio HiFi (and compatible Nanopore) reads and provides an automated, reproducible pipeline from raw reads to publication-ready mitogenomes.

---

### 📌 Workflow Overview

![MitoHiFi Workflow](https://github.com/Agustol/GenomeAssemblyAndAnnotation/blob/main/docs/figures/mitohifi_workflow.png)

**Figure.** Overview of the MitoHiFi pipeline for mitochondrial genome assembly, circularization, polishing, annotation, and quality control.

---

## 🔄 Pipeline Steps

### 1. Input: Long-Read Sequencing Data

The pipeline starts from whole-genome long-read data:

- PacBio HiFi reads (preferred)
- Oxford Nanopore long reads (optional)

These datasets contain both nuclear and mitochondrial DNA. Due to the high copy number of mitochondria, mtDNA reads are present at high coverage.

---

### 2. Mitochondrial Read Extraction

MitoHiFi identifies mitochondrial reads by:

- Mapping reads against a reference mitogenome  
- Using sequence similarity and k-mer filtering

This step enriches for mtDNA and removes most nuclear reads, including NUMTs.

**Output:**

![MitoHiFi Output](https://github.com/Agustol/GenomeAssemblyAndAnnotation/blob/main/docs/figures/mitohifi_workflow.png)
