
Across all reads, the frequency distribution of k-mers reflects:

- sequencing depth
- genome size
- heterozygosity
- repeat content
- sequencing error rate

---

## Conceptual view of a k-mer spectrum


::contentReference[oaicite:0]{index=0}


**How to read a k-mer spectrum**

- **x-axis**: k-mer multiplicity (coverage)
- **y-axis**: number of distinct k-mers
- Each peak corresponds to a biological component of the genome

This spectrum is the **only input** used by GenomeScope.

---

## Jellyfish output: example k-mer spectra

### Example 1 — Ideal diploid PacBio HiFi genome


::contentReference[oaicite:1]{index=1}


**Interpretation**

- Main peak → homozygous k-mers  
- Secondary peak at ~½ depth → heterozygous k-mers  
- Minimal low-coverage noise → low sequencing error  

Implications:
- Clean diploid genome
- Default `hifiasm` parameters are appropriate

---

### Example 2 — Highly heterozygous genome


::contentReference[oaicite:2]{index=2}


**Interpretation**

- Strong heterozygous peak
- Clear separation between heterozygous and homozygous peaks

Implications:
- Expect many haplotigs
- Purging strategy will strongly affect final assembly

---

### Example 3 — Polyploid or contaminated dataset


::contentReference[oaicite:3]{index=3}


**Interpretation**

- Multiple major peaks
- Peaks do not follow simple 1× / 2× relationships

Implications:
- Possible contamination, polyploidy, or mixed samples
- Investigate data quality before assembly

---

## GenomeScope 2.0 modeling

GenomeScope 2.0 fits a probabilistic mixture model to the Jellyfish k-mer spectrum.


::contentReference[oaicite:4]{index=4}


GenomeScope estimates:

- haploid genome size
- heterozygosity rate
- repeat and unique sequence content
- sequencing error rate
- effective k-mer coverage
- **model fit (%)**

GenomeScope does **not** assemble reads; it explains how the observed k-mers arise
from an underlying genome model.

---

## Interpreting the GenomeScope summary table

Example GenomeScope output:


