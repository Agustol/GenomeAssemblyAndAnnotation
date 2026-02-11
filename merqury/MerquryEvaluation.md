# Merqury Assembly Evaluation

Merqury evaluates genome assemblies using **k-mers** from high-quality reads (commonly Illumina).  
It provides **reference-free** estimates of:

- **Consensus accuracy (QV)**
- **Completeness (how many read k-mers are present in the assembly)**
- **Haplotype separation / phasing signal** (when primary + alternate assemblies are provided)

**Reference:** Rhie et al. 2020, *Genome Biology*  
https://genomebiology.biomedcentral.com/articles/10.1186/s13059-020-02134-9

---

## Files required in this repository (so figure links are NOT empty)

Place these files exactly here:

- `main/docs/figures/merqury_workflow.png`  (the workflow figure)
- `figures/merqury_spectra.png`   (your uploaded spectra plot)

Then GitHub will render them automatically.

---

## Graphical Summary: How Merqury Works

![Merqury workflow](https://github.com/Agustol/GenomeAssemblyAndAnnotation/blob/main/docs/figures/merqury_workflow.png)

**Merqury workflow overview.** Reads and assemblies are converted to k-mer databases using **meryl**.  
Merqury compares read k-mers vs assembly k-mers to classify k-mers (shared/correct, read-only/missing, and assembly-specific groups) and reports QV, completeness, and haplotype separation metrics.

---
