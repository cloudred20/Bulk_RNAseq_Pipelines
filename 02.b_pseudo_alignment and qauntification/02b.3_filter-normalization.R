## Setup DGEList and Compute Log2 CPM (Unfiltered, Non-Normalized)

library(edgeR) # well known package for differential expression analysis, but we only use for the DGEList object and for normalization methods
library(matrixStats) # let's us easily calculate stats on rows or columns of a data matrix

# Extract sample labels from metadata
sampleLabels <- targets$SampleNo

# Initialize the edgeR DGEList object using the raw count matrix from tximport
myDGEList <- DGEList(Txi$counts)

# Compute log2-transformed Counts Per Million (log2-CPM)
log2.cpm <- cpm(myDGEList, log=T)

# # Convert the matrix to a tibble, assign sample names as column headers, and pivot into a long format suitable for ggplot2 mapping.
log2.cpm.df <- as_tibble(log2.cpm, rownames = "geneID")
colnames(log2.cpm.df) <- c("geneID", sampleLabels)
log2.cpm.df.pivot <- pivot_longer(log2.cpm.df, # dataframe to be pivoted
                                  cols = colnames(log2.cpm.df[-1]), # column names to be stored as a SINGLE variable
                                  names_to = "samples", # name of that new variable (column)
                                  values_to = "expression") # name of new variable (column) storing all the values (data)

# Violin Plot of Log2 CPM Distributions
p1 <- ggplot(log2.cpm.df.pivot) +
  aes(x=samples, y=expression, fill=samples) +
  geom_violin(trim = F, show.legend = F) +
  stat_summary(fun = "median", 
               geom = "point", 
               shape = 95, 
               size = 10, 
               color = "black", 
               show.legend = F) +
  labs(y="log2 expression", x = "sample",
       title="Log2 Counts per Million (CPM)",
       subtitle="unfiltered, non-normalized",
       caption=paste0("produced on ", Sys.time())) +
  theme_bw() +
  theme(axis.text.x = element_text(angle = 90, vjust = -0.05))

p1

## Setup Filtering & Compute Log2 CPM (filtered, non-normalized)

# Calculate CPM on raw counts to determine which genes to keep
cpm <- cpm(myDGEList)
keepers <- rowSums(cpm>1)>=5 #user defined
myDGEList.filtered <- myDGEList[keepers,]

# Calculate log2-transformed CPM on the filtered dataset
log2.cpm.filtered <- cpm(myDGEList.filtered, log=T)
log2.cpm.filtered.df <- as_tibble(log2.cpm.filtered, rownames = "geneID")
colnames(log2.cpm.filtered.df) <- c("geneID", sampleLabels)

# Convert to tibble, rename columns dynamically, and pivot to long format
log2.cpm.filtered.df.pivot <- pivot_longer(log2.cpm.filtered.df, # dataframe to be pivoted
                                           cols = colnames(log2.cpm.df[-1]), # column names to be stored as a SINGLE variable
                                           names_to = "samples", # name of that new variable (column)
                                           values_to = "expression") # name of new variable (column) storing all the values (data)

# Violin Plot of Filtered, Non-Normalized Distributions
p2 <- ggplot(log2.cpm.filtered.df.pivot) +
  aes(x=samples, y=expression, fill=samples) +
  geom_violin(trim = F, show.legend = F) +
  stat_summary(fun = "median", 
               geom = "point", 
               shape = 95, 
               size = 10, 
               color = "black", 
               show.legend = F) +
  labs(y="log2 expression", x = "sample",
       title="Log2 Counts per Million (CPM)",
       subtitle="filtered, non-normalized",
       caption=paste0("produced on ", Sys.time())) +
  theme_bw() +
  theme(axis.text.x = element_text(angle = 90, vjust = -0.05))

p2

## Setup TMM normalization and Compute Log2 CPM

# Calculate TMM normalization factors to scale library sizes
myDGEList.filtered.norm <- calcNormFactors(myDGEList.filtered, method = "TMM")

# Compute normalized log2-CPM values using the calculated normalization factors
log2.cpm.filtered.norm <- cpm(myDGEList.filtered.norm, log=T)

# # Convert the matrix to a tibble, rename columns dynamically, and pivot to long format
log2.cpm.filtered.norm.df <- as_tibble(log2.cpm.filtered.norm, rownames = "geneID")
colnames(log2.cpm.filtered.norm.df) <- c("geneID", sampleLabels)
log2.cpm.filtered.norm.df.pivot <- pivot_longer(log2.cpm.filtered.norm.df, # dataframe to be pivoted
                                                cols = colnames(log2.cpm.df[-1]), # column names to be stored as a SINGLE variable
                                                names_to = "samples", # name of that new variable (column)
                                                values_to = "expression") # name of new variable (column) storing all the values (data)


# Violin Plot of Filtered, TMM-Normalized Distributions
p3 <- ggplot(log2.cpm.filtered.norm.df.pivot) +
  aes(x=samples, y=expression, fill=samples) +
  geom_violin(trim = F, show.legend = F) +
  stat_summary(fun = "median", 
               geom = "point", 
               shape = 95, 
               size = 10, 
               color = "black", 
               show.legend = F) +
  labs(y="log2 expression", x = "sample",
       title="Log2 Counts per Million (CPM)",
       subtitle="filtered, TMM normalized",
       caption=paste0("produced on ", Sys.time())) +
  theme_bw() +
  theme(axis.text.x = element_text(angle = 90, vjust = -0.05))

p3