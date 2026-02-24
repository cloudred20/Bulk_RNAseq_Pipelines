#!/bin/sh
# Script for filtering low quality reads and adapter contamination

#SBATCH --mem=8G 
#SBATCH -t 24:00:00

# Assumes:
#  - This script is submitted to a SLURM workload manager (due to #SBATCH directives).
#  - Paired-end FASTQ files are located in ./fastq_files/ and follow the naming convention *_R1_001.fastq.gz and *_R2_001.fastq.gz.
#  - The module system has Trimmomatic/0.39-Java-11 available, and loading it correctly sets the $EBROOTTRIMMOMATIC environment variable.
#  - Conda is initialized, and an environment named 'python3.7' contains multiqc.

module load Trimmomatic/0.39-Java-11
mkdir -p trimmomatic_results

# Process paired-end reads
for f in $(ls fastq_files/*.fastq.gz | sed 's/.*fastq_files\///' | sed 's/_R.*//' | sort -u) 
do 
    java -jar $EBROOTTRIMMOMATIC/trimmomatic-0.39.jar PE -phred33 \
    fastq_files/${f}_R1_001.fastq.gz fastq_files/${f}_R2_001.fastq.gz \
    trimmomatic_results/${f}_R1_001_paired.fastq.gz trimmomatic_results/${f}_R1_001_unpaired.fastq.gz \
    trimmomatic_results/${f}_R2_001_paired.fastq.gz trimmomatic_results/${f}_R2_001_unpaired.fastq.gz \
    ILLUMINACLIP:$EBROOTTRIMMOMATIC/adapters/TruSeq3-PE-2.fa:2:30:10 LEADING:30 TRAILING:30 SLIDINGWINDOW:4:20 MINLEN:70 
done

# Run FastQC on trimmed data
mkdir -p ./trimmomatic_results/fastqc_results
~/tools/FastQC/fastqc ./trimmomatic_results/*_paired.fastq.gz -o ./trimmomatic_results/fastqc_results

# Aggregate trimmed reports
conda activate python3.7
multiqc ./trimmomatic_results/fastqc_results/*_paired_fastqc.zip -o ./trimmomatic_results/fastqc_results/
conda deactivate