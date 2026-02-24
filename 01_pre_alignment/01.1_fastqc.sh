#!/bin/sh

# Script to run FastQC on the raw FASTQ files

# Assumes:
#  - FASTQ files are in ./fastq_files
#  - FastQC is installed at ~/tools/FastQC/fastqc (edit if different)
#  - multiqc is available in the conda environment

# Create output directory
mkdir -p fastqc_results

# Run FastQC
~/tools/FastQC/fastqc fastq_files/*.fastq.gz -o fastqc_results

# Run MultiQC to aggregate results
conda activate python3.7
multiqc fastqc_results/ -o fastqc_results/.
conda deactivate
