#!/bin/sh
# Script for pseudo-alignment and quantification

# Assumes:
#  - Conda is initialized, and an environment named 'python3.7' contains both kallisto and multiqc.
#  - Trimmed paired-end FASTQ files are located in ./trimmomatic_results/ and follow the naming convention *_R1_001_paired.fastq.gz and *_R2_001_paired.fastq.gz.
#  - A pre-built Kallisto index for the human transcriptome exists at ./reference/Homo_sapiens.GRCh38.cdna.all.index.
#  - The script is executed via a SLURM workload manager (e.g., using sbatch), which generates slurm-*.out log files in the current working directory for MultiQC to parse.

conda activate python3.7
mkdir -p kallisto_results

for f in $(ls ./trimmomatic_results/*_paired.fastq.gz | sed 's/.*_results\///' | sed 's/_R.*//' | sort -u)
do
    kallisto quant -i ./reference/Homo_sapiens.GRCh38.cdna.all.index \
    -o ./kallisto_results/${f} \
    ./trimmomatic_results/${f}_R1_001_paired.fastq.gz ./trimmomatic_results/${f}_R2_001_paired.fastq.gz
done

multiqc ./slurm-*.out -p -o ./kallisto_results/.
conda deactivate