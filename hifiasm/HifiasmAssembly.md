# How Hifiasm Works

**Figure 1 (assembly graph and haplotype bubbles):**  
![Hifiasm workflow](https://github.com/Agustol/GenomeAssemblyAndAnnotation/blob/main/docs/figures/hifiasm_algorithm.png)

Hifiasm assembles genomes from PacBio HiFi long reads by building an assembly graph based on read overlaps.

Instead of directly joining reads into long sequences, hifiasm first represents the genome as a network in which:

- Nodes represent DNA segments built from overlapping reads  
- Edges represent overlaps between segments  
- Paths represent possible genome sequences  

Because diploid organisms have two similar but not identical chromosome copies, real genetic differences create alternative paths in the graph. These alternative paths form structures called **bubbles** (see Figure 1). Each branch of a bubble corresponds to one haplotype.

Hifiasm uses the long length and high accuracy of HiFi reads to determine which reads support each branch. Reads that consistently follow the same branches are grouped together, allowing the two haplotypes to be separated. This process is known as **phasing**.

After resolving bubbles, the graph is simplified and converted into long continuous sequences (contigs).

## Output Files

- **Primary contigs (`*.p_ctg.fa`)**: main haplotype assembly  
- **Alternate contigs (`*.a_ctg.fa`)**: second haplotype  
- **Assembly graph (`*.gfa`)**: graph representation  

## Summary

Hifiasm works as follows:

1. Builds an overlap-based assembly graph from HiFi reads  
2. Identifies alternative paths caused by heterozygosity  
3. Separates haplotypes using read support  
4. Extracts phased genome sequences  

This graph-based approach enables accurate and biologically realistic genome assemblies from PacBio HiFi data.

