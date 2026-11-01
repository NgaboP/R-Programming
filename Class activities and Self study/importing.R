
# ============================================================
# ASSIGNMENT: IMPORTING DATA FROM A DATABASE MANAGEMENT SYSTEM
# DATABASE: MySQL
# ============================================================

# INTRODUCTION:
# This section demonstrates how to import data from a MySQL
# database into RStudio using the DBI and RMariaDB packages.
# The database used is called "student_management", which
# contains three tables: students, courses, and enrollments.
#
# After establishing a database connection, the tables are
# imported into R for inspection and further analysis.
# ============================================================


# 1. INSTALLING AND LOADING REQUIRED PACKAGES
# Packages provide functions that allow R to communicate
# with MySQL and perform data manipulation.

# Install packages (run only once)
install.packages("DBI")
install.packages("RMariaDB")


# Load the installed packages
library(DBI)
library(RMariaDB)



# 2. ESTABLISHING A DATABASE CONNECTION
# The dbConnect() function establishes a connection between
# RStudio and the MySQL database.
#
# RMariaDB::MariaDB() specifies the database driver.
# The connection details identify the MySQL server and database.

con <- dbConnect(
  RMariaDB::MariaDB(),
  host = "localhost",
  port = 3306,
  dbname = "student_management",
  user = "root",
  password = ""
)


# 3. VERIFYING THE DATABASE CONNECTION
# dbIsValid() checks whether the database connection is active.
# It returns TRUE if the connection is valid.

dbIsValid(con)


# 4. IDENTIFYING AVAILABLE DATABASE TABLES
# dbListTables() retrieves the names of all tables available
# in the connected MySQL database.

dbListTables(con)


# 5. IMPORTING TABLES INTO R
# dbReadTable() retrieves data from a specified MySQL table
# and stores it as a data frame in R.
#
# The following commands import the three tables.

students <- dbReadTable(con, "students")

courses <- dbReadTable(con, "courses")

enrollments <- dbReadTable(con, "enrollments")


# 6. VIEWING THE IMPORTED DATA
# head() displays the first six rows of each imported table.
# This helps to verify that the data has been imported correctly.

head(students)

head(courses)

head(enrollments)


# 7. IDENTIFYING COLUMN NAMES
# names() displays the column names of each data frame.
# This helps identify the variables available for analysis.

variable.names(students)

variable.names(courses)
variable.names(enrollments)


# 8. EXAMINING THE DATA STRUCTURE
# str() displays the internal structure of each data frame,
# including the number of observations, variables, and data types.

str(students)

str(courses)

str(enrollments)


# 9. GENERATING SUMMARY STATISTICS
# summary() provides descriptive summaries of the imported data.
# The output depends on the data type of each column.

summary(students)

summary(courses)

summary(enrollments)


# 10. CHECKING THE DIMENSIONS OF THE DATA
# dim() returns the number of rows and columns in each table.
# The first value represents rows, while the second represents columns.

dim(students)

dim(courses)

dim(enrollments)


# 11. CHECKING FOR MISSING VALUES
# is.na() identifies missing values in the imported data.
# colSums() counts the missing values in each column.
# This helps assess the completeness of the imported datasets.

colSums(is.na(students))

colSums(is.na(courses))

colSums(is.na(enrollments))


# 12. CLOSING THE DATABASE CONNECTION
# dbDisconnect() terminates the connection between RStudio
# and MySQL after completing the data import process.

dbDisconnect(con)


# ============================================================
# END OF DBMS DATA IMPORT
# ============================================================
