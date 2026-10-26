library(DBI)
library(RMariaDB)
library(dplyr)
library(ggplot2)

#Import data from MySQL (DBMS)
#------------------------

con <- dbConnect(
  RMariaDB::MariaDB(),
  host = "localhost",
  port = 3306,
  dbname = "student_management",
  user = "root",
  password = ""
)

dbListTables(con)

dbIsValid(con)

# Import tables into R
students <- dbReadTable(con, "students")
courses <- dbReadTable(con, "courses")
enrollments <- dbReadTable(con, "enrollments")

# Display data
head(students)
head(courses)
head(enrollments)


#check Column names
names(students)
names(courses)
names(enrollments)

# Structure of imported data

str(students)
str(courses)
str(enrollments)

#Importing data from Statistical package
#---------------------------------------

# Load the datasets package
library(datasets)

# Load iris dataset from the package
data("iris", package = "datasets")

# Display the first six rows
head(iris)

# Display column names
names(iris)

# Check the structure
str(iris)

# Display summary statistics
summary(iris)

# Number of rows and columns
dim(iris)


#Testing GitHub connection
#------------------------
