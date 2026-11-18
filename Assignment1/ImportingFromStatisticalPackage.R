
# ============================================================
# ASSIGNMENT: IMPORTING DATA FROM STATISTICAL SOFTWARE
# STATISTICAL SOFTWARE: SPSS
# FILE FORMAT: .sav
# ============================================================

# INTRODUCTION:
# This section demonstrates how to import data from an SPSS
# statistical software file into RStudio using the haven package.
#
# The imported dataset will be inspected to understand its
# variables, data types, dimensions, and summary statistics.
# ============================================================


# 1. INSTALLING AND LOADING THE REQUIRED PACKAGE

# Install the haven package (run only once)
install.packages("haven")

# Load the package into the current R session
library(haven)


# 2. IMPORTING DATA FROM AN SPSS FILE
# read_sav() imports data stored in the SPSS .sav file format.
# file.choose() opens a file selection window to locate the file.

statistical_data <- read_sav(file.choose())


# 3. VIEWING THE IMPORTED DATA
# head() displays the first six observations.
# This helps verify that the dataset was imported successfully.

head(statistical_data)


# 4. IDENTIFYING COLUMN NAMES
# names() displays all variable names in the imported dataset.

names(statistical_data)


# 5. EXAMINING THE DATA STRUCTURE
# str() displays the structure of the dataset, including
# the number of observations, variables, and their data types.

str(statistical_data)


# 6. GENERATING SUMMARY STATISTICS
# summary() provides descriptive statistics for the variables,
# including minimum, maximum, median, and mean where applicable.

summary(statistical_data)


# 7. CHECKING THE DATASET DIMENSIONS
# dim() returns the number of rows and columns.
# The first value represents observations, while the second
# represents variables.

dim(statistical_data)


# 8. CHECKING FOR MISSING VALUES
# is.na() identifies missing values in the dataset.
# colSums() calculates the number of missing values in each column.

colSums(is.na(statistical_data))


# ============================================================
# END OF STATISTICAL DATA IMPORT
# ============================================================
