# Read experimental metadata (sample names, groups, covariates)
targets <- read.delim("sample_design.txt", sep = "\t", stringsAsFactors = FALSE)
targets

# Load required packages
library(rhdf5) # provides functions for handling hdf5 file formats (kallisto outputs bootstraps in this format)
library(tidyverse) # provides access to Hadley Wickham's collection of R packages for data science, which we will use throughout the course
library(tximport) # package for getting Kallisto results into R
library(ensembldb) # helps deal with ensembl
library(EnsDb.Hsapiens.v86) # replace with your organism-specific database package

# Build the Transcript-to-Gene Mapping
Tx <- transcripts(EnsDb.Hsapiens.v86, columns=c("tx_id", "gene_name"))
Tx <- as_tibble(Tx)
Tx <- dplyr::rename(Tx, target_id = tx_id)
Tx <- dplyr::select(Tx, "target_id", "gene_name")

# Import & Aggregate Quantifications with tximport
Txi <- tximport(file.path("kallisto_results", targets$SampleNo, 
                          "abundance.tsv"),
                type = "kallisto", 
                tx2gene = Tx, 
                txOut = F, #determines whether your data represented at transcript or gene level
                countsFromAbundance = "lengthScaledTPM",
                ignoreTxVersion = T)

# Verify Imported Data Structure
head(Txi, n = 1)