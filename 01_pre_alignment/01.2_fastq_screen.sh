#!/bin/sh
# Script for identifying and filtering contaminant RNAs

# Assumes:
#  - FASTQ files are in ./fastq_files and end in .fastq.gz
#  - FastQ-Screen is installed at ~/tools/FastQ-Screen-0.14.1/fastq_screen (edit if different)
#  - A valid configuration file exists at ./config/fastq_screen.conf
#  - The module system has Bowtie2/2.3.4.2-foss-2018b available to load
#  - Conda is initialized, and an environment named 'python3.7' contains multiqc

module load Bowtie2/2.3.4.2-foss-2018b
mkdir -p fastq_screen_results

for f in $(ls fastq_files/*fastq.gz)
do
    ~/tools/FastQ-Screen-0.14.1/fastq_screen --conf ./config/fastq_screen.conf ${f} --outdir fastq_screen_results
done

conda activate python3.7  
multiqc fastq_screen_results/ -o fastq_screen_results/  
conda deactivate