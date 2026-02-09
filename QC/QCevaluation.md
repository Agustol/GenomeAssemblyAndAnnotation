
# Step 1 — k-mer evaluation (PacBio HiFi)

## Overview

Before genome assembly, we evaluate PacBio HiFi reads using **k-mer analysis**.
This step provides reference-free estimates of genome properties and serves as a
diagnostic tool to guide downstream assembly decisions.

We use:

- **Jellyfish** for k-mer counting
- **GenomeScope 2.0** for probabilistic modeling of the k-mer spectrum

All analyses are performed directly on **PacBio HiFi CCS reads (single-end)**.

---

## What is a k-mer?

A **k-mer** is a substring of length *k* extracted from sequencing reads.

Example (k = 5):

