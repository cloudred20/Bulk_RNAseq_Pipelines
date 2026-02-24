# Under Construction: Expected release: Q1 2026.

## HPC-Ready Pipelines for Bulk RNA-seq Processing and Analysis
This repository provides an HPC-optimized workflow for processing and analyzing bulk RNA-seq data using . Integrates best-practice tools for sequencing quality control, read trimming, alignment or pseudo-alignment, quantification, differential gene expression, and functional enrichment. Designed for scalability and reproducibility on high-performance computing clusters, this workflow enables robust transcriptomic analysis across large sample cohorts.

Bulk RNA-seq enables quantitative assessment of gene expression changes across biological conditions. This repository supports both alignment-free (kallisto) and alignment-based (STAR) workflows to accommodate different analysis needs and computational environments.

### Four major steps in RNA-seq analysis include:
#### (1) Pre-alignment Quality Control and Read Processing
* Assess raw sequencing quality using **FastQC 0.12.1** to evaluate per-base quality scores, GC content, duplication rates, and adapter contamination.
* Detect contaminant sequences (e.g., rRNA or non-target species) using **FastQ Screen 0.14.1** where applicable.
* Remove adapters and low-quality bases using **Trimmomatic 0.39** in paired-end mode with sliding-window trimming and minimum length filtering.

#### (2) Read Alignment or Pseudo-alignment and Quantification

**Two supported workflows:**

**A. Pseudo-alignment Workflow (Fast and scalable)**
* Perform transcript quantification using **kallisto 0.46.0** against the GRCh38.p13 reference transcriptome.
* Filter low-abundance genes and normalize expression using **edgeR 3.38.4** with TMM normalization.
* Evaluate sample relationships using PCA and clustering diagnostics in R.
* Perform differential gene expression analysis using **limma 3.52.4**.

**B. Alignment-based Workflow (full genome alignment)**
* Align reads to GRCh38.p13 using **STAR 2.7.1a**.
* Convert, sort, and index BAM files using **samtools 1.12**.
* Generate alignment QC metrics using **Qualimap 2.2.1**.
* Quantify reads at the gene level using featureCounts in **subread 2.0.2** with GENCODE annotations.

#### (3) Differential Expression and Statistical Analysis
* Estimate dispersion and model gene expression differences using limma or DESeq2, depending on workflow.
* Apply multiple-testing correction (Benjamini–Hochberg) to identify significantly differentially expressed genes.
* Visualize results using:
  * PCA plots
  * Heatmaps (pheatmap / gplots)
  * Volcano plots
  * UpSet plots for gene set overlaps

#### (4) Functional Enrichment and Biological Interpretation
* Perform Gene Ontology (GO) and pathway enrichment using **clusterProfiler 4.4.4**.
* Run Gene Set Enrichment Analysis (GSEA) using MSigDB gene sets.
* Integrate external gene lists (e.g., tissue-specific signatures from Human Protein Atlas).
* Generate publication-quality visualizations using ggplot2.
* Build interaction networks in **Cytoscape 3.9.1**.

#### Reporting & Aggregation:
* Aggregates reports from FastQC, FastQ Screen, Trimmomatic, kallisto, STAR, samtools etc using **MultiQC 1.10**.

### Resources

### Publication 
* https://doi.org/10.1016/j.jcmgh.2025.101466
