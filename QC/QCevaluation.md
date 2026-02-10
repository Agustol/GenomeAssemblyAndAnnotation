## GenomeScope-based k-mer analysis (PacBio HiFi, k=21, p=2)

We performed k-mer spectrum analysis using **Jellyfish** and **GenomeScope 2.0**
to characterize the genome prior to assembly. All analyses were run on PacBio
HiFi CCS reads using *k = 21* and assuming diploidy (*p = 2*).

---

## Conceptual overview: how k-mer spectra work

![Conceptual k-mer spectrum](QC/kmers/figures/kmer_spectrum_schematic.png)

This schematic illustrates how k-mer spectra are generated and why they encode
genome properties.

Briefly:

1. Reads are decomposed into overlapping k-mers.
2. Each distinct k-mer is counted across all reads.
3. K-mers are grouped by multiplicity (coverage).
4. The resulting histogram reflects:
   - sequencing depth,
   - heterozygosity,
   - repeat content,
   - sequencing error.

GenomeScope fits a probabilistic model to this histogram to infer genome-wide
properties without requiring a reference genome.

---

## Observed k-mer spectrum (log-scaled view)

![GenomeScope profile, log scale](docs/figures/kmer/kmer_spectrum_normal_log.png)

This plot shows the **full k-mer spectrum on a log-scaled y-axis**, allowing
visualization of low-frequency k-mers (errors) and high-copy k-mers (repeats).

### Key features

- **Error k-mers**  
  The steep left-hand decay at very low coverage (<10×) corresponds to
  sequencing errors. Their low abundance and rapid drop-off are consistent with
  high-quality PacBio HiFi data.

- **Heterozygous peak (~½ coverage)**  
  A small shoulder at approximately half the main peak reflects heterozygous
  k-mers, arising from sites where the two haplotypes differ.

- **Homozygous peak (~34×)**  
  The dominant peak represents homozygous k-mers and defines the effective
  k-mer coverage (*kcov ≈ 34*).

- **High-coverage tail**  
  The long right-hand tail corresponds to repetitive sequence, where k-mers
  appear multiple times in the genome.

This global view confirms a clean, diploid genome with low error and moderate
repeat content.

---

## Model fit and peak structure (linear-scaled view)

![GenomeScope profile, linear scale](docs/figures/kmer/kmer_spectrum_normal.png)

The linear-scale view highlights the **central coverage range** where GenomeScope
fits its model.

- Blue bars: observed k-mer counts  
- Black curve: fitted GenomeScope model  
- Yellow curve: unique (single-copy) sequence  
- Orange curve: sequencing errors  
- Dashed lines: inferred k-mer peaks

The close agreement between observed data and the fitted model across the main
peak indicates that GenomeScope assumptions (diploidy, uniform coverage) are
largely satisfied.

---

## GenomeScope 2.0 model results (k = 21, p = 2)

GenomeScope summary statistics:

| Property | Estimate |
|--------|----------|
| Haploid genome size | 1.068–1.069 Gb |
| Homozygous (aa) | ~99.56% |
| Heterozygous (ab) | ~0.43% |
| Unique sequence | ~996–997 Mb |
| Repetitive sequence | ~72 Mb |
| k-mer coverage | ~34× |
| Read error rate | ~0.106% |
| Model fit | ~89–96% |

### Interpretation of key values

**Genome length**  
The estimated haploid genome size (~1.07 Gb) is consistent with expectations for
a medium-sized avian genome and provides a reliable target for assembly size and
memory planning.

**Heterozygosity (~0.43%)**  
This level of heterozygosity is moderate and explains the visible but relatively
small heterozygous peak. Assemblies are expected to contain haplotigs, but
extreme graph complexity is unlikely.

**Repeat content (~72 Mb)**  
Approximately 6–7% of the genome is inferred to be repetitive. The extended
high-coverage tail in the spectrum reflects this component and predicts some
collapse of repeats during assembly.

**Error rate (~0.1%)**  
The very low error rate is characteristic of HiFi data and explains the weak
low-coverage noise in the spectrum.

**Model fit (89–96%)**  
Most k-mers are well explained by the diploid GenomeScope model. Minor deviations
likely reflect repetitive sequence and coverage heterogeneity rather than
contamination or incorrect ploidy.

---

## Choice of k for PacBio HiFi

We used **k = 21**, which balances robustness and resolution at moderate coverage.
For confirmation, analyses at **k = 31** may be performed; consistent estimates
across k values indicate stable inference.

---

## What k-mer analysis does *not* provide

k-mer analysis does **not**:

- assemble reads,
- resolve long structural variants,
- identify specific repeat families,
- replace assembly-level QC.

Instead, it provides a **pre-assembly diagnostic framework** that explains and
predicts downstream assembly behavior.

---

## Implications for downstream assembly

| Observation | Expected impact |
|------------|-----------------|
| Moderate heterozygosity | Haplotigs present; purging required |
| Low error rate | Clean assembly graph |
| Moderate repeat content | Some repeat collapse |
| Good model fit | Diploid assembly assumptions valid |

Together, these results indicate that the dataset is well suited for standard
HiFi assembly workflows (e.g. `hifiasm`) followed by haplotig purging and
scaffolding.
