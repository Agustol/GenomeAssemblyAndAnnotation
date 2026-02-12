## Reference-Guided Scaffolding with **RagTag**

**RagTag** is a widely used bioinformatics toolset designed to improve and scaffold genome assemblies by leveraging homology to a high-quality reference genome. It extends and generalizes the principles introduced by RaGOO, offering a flexible and robust framework for ordering and orienting draft assembly contigs relative to a trusted reference sequence.

![RagTag Workflow](https://github.com/Agustol/GenomeAssemblyAndAnnotation/blob/main/docs/figures/ragtag_scaffolding_workflow.png)

### Key Concepts

- **Reference that informs scaffolding:**  
  RagTag uses a *reference assembly* as a structural guide. By aligning draft contigs (the *query assembly*) to a reference genome using high-sensitivity whole-genome alignments, RagTag can infer the correct linear order and orientation of sequences. :contentReference[oaicite:1]{index=1}

- **Primary alignment selection:**  
  For each query sequence, the **longest and highest-confidence alignment** to the reference is designated as its “primary alignment.” These primary alignments are then used to assign contigs to reference chromosomes and determine their relative positions and orientations. :contentReference[oaicite:2]{index=2}

- **Ordering and orientation:**  
  Query contigs are ordered according to the coordinate positions of their primary alignments on the reference. Orientation is set to match that of the primary alignment, producing a scaffold that reflects the reference’s structure. :contentReference[oaicite:3]{index=3}

- **Gap placement and sizing:**  
  Adjacent contigs are connected by artificial gaps (e.g., 100 bp of `N`s by default), indicating unknown sequence between them. Optionally, RagTag can *infer gap lengths* based on reference alignment coordinates when possible. :contentReference[oaicite:4]{index=4}

### When to Use RagTag

RagTag is most appropriate when:

- A high-quality reference genome from a **closely related genotype or species** is available.  
- Contigs from a draft assembly require **ordering and orientation** to reach chromosome scale.  
- You aim to scaffold assemblies while preserving the original sequences (RagTag does *not* alter the input contigs). :contentReference[oaicite:5]{index=5}

### Limitations & Best Practices

- Reference-guided scaffolding can introduce bias when the query and reference differ substantially in structure or content.  
- Users should ensure that reference choice reflects the biology of the organism to avoid incorrect scaffolding decisions.  
- RagTag can be combined with Hi-C or other long-range data to refine scaffolds further when structural differences are expected between query and reference.

### Common RagTag Commands

- `ragtag.py scaffold <REF> <QUERY> -o <OUT>` — scaffold the query using the reference  
- `ragtag.py correct` — identify and break putative misassemblies  
- `ragtag.py patch` — fill gaps and make joins from complementary assemblies  
- `ragtag.py merge` — merge multiple scaffold solutions

The tool suite also includes utilities to convert, validate, and manipulate assembly and scaffold file formats. :contentReference[oaicite:6]{index=6}

