# 🧬 Genome Assembly Evaluation with BUSCO

This repository documents the evaluation of genome assemblies using BUSCO (Benchmarking Universal Single-Copy Orthologs). BUSCO measures genome completeness by searching for conserved genes expected to be present in a given lineage.

---

## 📌 What is BUSCO?

BUSCO assesses genome quality using curated sets of near-universal, single-copy orthologous genes. These genes are highly conserved within major taxonomic groups and are expected to be present in complete genomes.

Each BUSCO gene is classified as:

- Complete (C)
  - Single-copy (S)
  - Duplicated (D)
- Fragmented (F)
- Missing (M)

These categories provide an objective measure of gene-space completeness.

---

## 📊 How BUSCO Works (Graphical Summary)

![BUSCO workflow](figures/busco_workflow.png)

**Figure 1.** Conceptual overview of the BUSCO pipeline for genome assembly evaluation.

### Workflow Description

1. **Input Assembly**  
   A genome FASTA file is provided as input.

2. **Gene Prediction**  
   BUSCO predicts genes using built-in gene-finding tools such as MetaEuk or Augustus.

3. **Ortholog Search**  
   Predicted proteins are compared against lineage-specific BUSCO reference databases.

4. **Gene Classification**  
   Each BUSCO gene is classified as:
   - Complete and single-copy
   - Complete and duplicated
   - Fragmented
   - Missing

5. **Summary Report**  
   Results are summarized in tables and plots showing genome completeness.

---




