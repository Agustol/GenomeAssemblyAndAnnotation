# Merqury Assembly Evaluation

Merqury evaluates genome assemblies using **k-mers** from high-quality reads (commonly Illumina).  
It provides **reference-free** estimates of:

- **Consensus accuracy (QV)**
- **Completeness (how many read k-mers are present in the assembly)**
- **Haplotype separation / phasing signal** (when primary + alternate assemblies are provided)

**Reference:** Rhie et al. 2020, *Genome Biology*  
https://genomebiology.biomedcentral.com/articles/10.1186/s13059-020-02134-9

**Merqury workflow overview.** Reads and assemblies are converted to k-mer databases using **meryl**.  
Merqury compares read k-mers vs assembly k-mers to classify k-mers (shared/correct, read-only/missing, and assembly-specific groups) and reports QV, completeness, and haplotype separation metrics.

![Merqury workflow](https://github.com/Agustol/GenomeAssemblyAndAnnotation/blob/main/docs/figures/merqury_workflow.png)

---
## Merqury Spectra Plot Interpretation

![Merqury spectra plot](figures/merqury_spectra.png)

**Figure.** Merqury k-mer spectra plot showing how sequencing read k-mers are represented in the primary and alternate assemblies.

In this plot, the x-axis shows k-mer multiplicity in the read dataset (coverage), and the y-axis shows the number of distinct k-mers at each multiplicity.

Four k-mer categories are shown:

- **Read-only (gray/black):** k-mers present in reads but absent from the assembly  
- **Primary-only (red):** k-mers present only in the primary assembly  
- **Alternate-only (blue):** k-mers present only in the alternate assembly  
- **Shared (green):** k-mers present in both reads and assembly  

---

### Low-multiplicity region (<5×)

The tall peak near multiplicity 1–5 represents low-frequency k-mers, mainly caused by sequencing errors and noise.  
These k-mers are mostly classified as read-only, indicating that read errors were not incorporated into the assembly. This suggests good consensus accuracy.

---

### Heterozygous peak (~40–50×)

The peak around 40–50× corresponds to heterozygous k-mers that occur in only one haplotype.  
In this region, primary-only (red) and alternate-only (blue) k-mers dominate, indicating that haplotype-specific sequences are separated between the two assemblies. This reflects effective diploid phasing.

---

### Homozygous peak (~80–100×)

The major peak around 80–100× represents homozygous k-mers shared between both haplotypes.  
This region is dominated by shared (green) k-mers, indicating high assembly completeness and correct representation of conserved genomic regions.

The presence of some primary-only signal suggests minor duplication or uneven haplotype representation, which is common in diploid assemblies.

---

### High-multiplicity tail (>120×)

The low-frequency tail at high multiplicities corresponds to repetitive and high-copy sequences such as transposable elements and satellite repeats.  
The moderate size of this tail suggests reasonable repeat representation without major collapse.

---

### Overall Interpretation

This spectra profile indicates:

- Low incorporation of sequencing errors  
- Clear separation of heterozygous k-mers between haplotypes  
- Strong representation of homozygous shared sequence  
- No extreme repeat collapse  

Together, these features are consistent with a high-quality, complete, and well-phased diploid genome assembly.

