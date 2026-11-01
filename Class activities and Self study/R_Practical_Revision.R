# ============================================================
# R PROGRAMMING - PRACTICAL REVISION GUIDE
# Based on the lecturer's practical notes
# ============================================================


# 1. SUMMARY STATISTICS
# ------------------------------------------------------------

# Display summary statistics of the built-in cars dataset
summary(cars)

# Create a numeric vector
x <- c(0.5, 0.6)

# Create a vector containing students' ages
age <- c(20, 35, 32, 29)

# Display summary statistics of age
summary(age)

# Calculate the average age
age <- c(35, 24, 18, 24)
mean(age)


# 2. DATA TYPES AND VECTORS
# ------------------------------------------------------------

# Create a logical vector
x <- c(TRUE, FALSE)

# Alternative way of writing logical values
x <- c(T, F)

# Create a character vector
x <- c("a", "b", "c")

# Create a vector containing gender categories
gender <- c("M", "F", "F", "M")

# Create an integer sequence from 9 to 29
x <- 9:29

# Create a complex number vector
x <- c(1+0i, 2+4i)

# Check the data type of an object
class(x)


# 3. MATRICES AND MATRIX OPERATIONS
# ------------------------------------------------------------

# Create a matrix containing numbers from 1 to 6
# The matrix will have 2 rows and 3 columns
x <- matrix(1:6, nrow = 2, ncol = 3)

# Display the first matrix
x

# Create another matrix with 3 rows and 2 columns
y <- matrix(1:6, nrow = 3, ncol = 2)

# Display the second matrix
y

# Perform matrix multiplication
x %*% y


# 4. LISTS
# ------------------------------------------------------------

# Create a list containing different data types
x <- list(1, "a", TRUE, 1 + 4i)

# Display the list
x


# 5. FACTORS
# ------------------------------------------------------------

# Create a factor for categorical data
x <- factor(c("yes", "yes", "no", "yes", "no"))

# Display the factor and its levels
x
levels(x)


# 6. MISSING VALUES (NA)
# ------------------------------------------------------------

# Create a vector containing missing values
x <- c(1, 2, NA, 10, 3)

# Identify missing values
is.na(x)

# Create a vector containing the text "NA"
# Note: "NA" in quotation marks is text, not a missing value
x <- c(1, 2, 4, "NA", 5)

# Identify actual missing values and store the results
bad <- is.na(x)

# Display the logical results
print(bad)

# Select elements that are not missing
x[!bad]

# Create two vectors with missing values
x <- c(1, 2, NA, 4, NA, 5)
y <- c("a", "b", NA, "d", NA, "f")

# Identify positions where neither vector has missing values
good <- complete.cases(x, y)

# Display the results
good


# 7. DATA COERCION
# ------------------------------------------------------------

# TRUE is treated as 1 and FALSE as 0 in numeric calculations
sum(c(TRUE, TRUE, FALSE, FALSE, FALSE))

# When a character is included in a vector,
# R converts the other elements to character
x <- c(1, 2, "hello", 4)

# Check the resulting data type
class(x)


# 8. CREATING A DATA FRAME
# ------------------------------------------------------------

# Create a vector containing student identification numbers
studentID <- c(1, 2, 3, 4, 5)

# Create a vector containing mathematics scores
# NA represents a missing value
math_score <- c(12, 17, 10, 9, NA)

# Create a vector containing students' genders
gender <- c("M", "F", "M", "M", "F")

# Create a vector containing IT scores
it_score <- c(13, 18, 11, 10, 19)

# Combine all vectors into one data frame
scoredata <- data.frame(studentID, gender, math_score, it_score)

# Display the data frame
scoredata

# Open the dataset in RStudio's spreadsheet viewer
View(scoredata)


# 9. CREATING DATA USING THE KEYBOARD
# ------------------------------------------------------------

# Create an empty data frame with three numeric columns
data_class2 <- data.frame(
  height = numeric(0),
  weight = numeric(0),
  bmi = numeric(0)
)

# Open the data editor to enter information manually
data_class2 <- edit(data_class2)


# 10. IMPORTING DATA FROM A TEXT FILE
# ------------------------------------------------------------

# Import data from a text file
# file.choose() allows you to browse and select the file
data_class <- read.table(file.choose())

# Display the variable names
variable.names(data_class)

# Display the first six rows
head(data_class)

# Display the last six rows
tail(data_class)

# Select rows 10 to 20 and display all columns
data_class[10:20, ]

# Display summary statistics of the WEIGHT column
summary(data_class$WEIGHT)

# Count the number of observations in WEIGHT
length(data_class$WEIGHT)

# Select all columns except the first column
data_class[, -1]

# Select only the WEIGHT column
data_class$WEIGHT


# 11. IMPORTING BUILT-IN DATASETS
# ------------------------------------------------------------

# Display datasets available in R
data()

# Load the airquality dataset
data("airquality")

# Display the variable names
variable.names(airquality)

# Display the structure of the dataset
str(airquality)

# Load the iris dataset
data("iris")

# Display the first six observations
head(iris)


# 12. EXPLORATORY DATA ANALYSIS (EDA)
# ------------------------------------------------------------

# Display the complete dataset
data_class

# Display summary statistics of all variables
summary(data_class)

# Examine the structure of the dataset
str(data_class)

# Calculate the mean of each row
apply(data_class, 1, mean)

# Calculate standard deviation of each column
apply(data_class, 2, sd)

# Calculate mean and standard deviation of HEIGHT
c(mean(data_class$HEIGHT), sd(data_class$HEIGHT))

# Calculate mean and standard deviation of WEIGHT
c(mean(data_class$WEIGHT), sd(data_class$WEIGHT))

# Give names to the calculated statistics
c(Mean = mean(data_class$HEIGHT), SD = sd(data_class$HEIGHT))
c(Mean = mean(data_class$WEIGHT), SD = sd(data_class$WEIGHT))


# 13. RELATIONSHIP BETWEEN CATEGORICAL AND CONTINUOUS VARIABLES
# ------------------------------------------------------------

# Load the iris dataset
data("iris")

# Display the first six observations
head(iris)

# Calculate the overall average petal length
mean(iris$Petal.Length)

# Calculate average petal length for each species
mean(iris$Petal.Length[iris$Species == "setosa"])
mean(iris$Petal.Length[iris$Species == "versicolor"])
mean(iris$Petal.Length[iris$Species == "virginica"])

# Calculate the mean for each species using by()
by(iris$Petal.Length, iris$Species, mean)

# Calculate standard deviation for each species
by(iris$Petal.Length, iris$Species, sd)

# Display summary statistics for each species
by(iris$Petal.Length, iris$Species, summary)

# Create a boxplot comparing sepal length across species
boxplot(
  Sepal.Length ~ Species,
  data = iris,
  main = "Comparison of Categorical vs Quantitative"
)


# 14. RELATIONSHIP BETWEEN TWO CATEGORICAL VARIABLES
# ------------------------------------------------------------

# Convert the built-in UCBAdmissions dataset into a data frame
ucba <- data.frame(UCBAdmissions)

# Display the first six observations
head(ucba)

# Create a contingency table for gender and admission
cross <- xtabs(Freq ~ Gender + Admit, data = ucba)

# Display the contingency table
cross

# Calculate admission proportions for each gender
prop.table(cross, 1)

# Create a contingency table for Department F only
cross2 <- xtabs(
  Freq ~ Gender + Admit,
  data = ucba[ucba$Dept == "F", ]
)

# Calculate proportions for Department F
prop.table(cross2, 1)


# 15. BAR CHARTS
# ------------------------------------------------------------

# Create a dataset containing product sales
dat <- read.table(
  text = "ProdA ProdB ProdC ProdD
1 110 50 60 70
2 120 50 80 65",
  header = TRUE
)

# Create a grouped bar chart
# beside = TRUE places bars next to each other
barplot(
  as.matrix(dat),
  beside = TRUE,
  col = c("red", "green")
)

# Create another dataset with seven categories
dat <- read.table(
  text = "A B C D E F G
1 10 80 30 90 70 60 90
2 20 50 70 50 40 10 40
3 60 80 80 60 60 30 160
4 20 40 70 80 20 10 70",
  header = TRUE
)

# Create a bar chart from the dataset
barplot(as.matrix(dat))


# 16. SCATTER PLOTS AND CORRELATION
# ------------------------------------------------------------

# Create a scatter plot showing weight against height
plot(WEIGHT ~ HEIGHT, data = data_class)

# Create a scatter plot using column names
plot(data_class$HEIGHT, data_class$WEIGHT)

# Create a scatter plot using column positions
plot(data_class[, 1], data_class[, 2], main = "Graph")

# Calculate the correlation between height and weight
cor(data_class$HEIGHT, data_class$WEIGHT)


# 17. LINEAR REGRESSION MODELS
# ------------------------------------------------------------

# Plot the relationship between weight and height
plot(WEIGHT ~ HEIGHT, data = data_class)

# Add a linear regression line to the scatter plot
abline(lm(WEIGHT ~ HEIGHT, data = data_class)$coefficient)

# Build a linear regression model
# HEIGHT is the dependent variable
# WEIGHT is the independent variable
data_lm <- lm(HEIGHT ~ WEIGHT, data = data_class)

# Display the regression results
summary(data_lm)

# Display diagnostic plots for the regression model
plot(data_lm)

# Build a regression model with WEIGHT as the dependent variable
lm(WEIGHT ~ HEIGHT, data = data_class)


# 18. HISTOGRAMS
# ------------------------------------------------------------

# Create a histogram showing the distribution of height
hist(data_class$HEIGHT)

# Create a histogram showing the distribution of weight
hist(data_class$WEIGHT, col = "blue")


# 19. LINEAR REGRESSION WITH LOWESS LINE
# ------------------------------------------------------------

# Plot weight against height
plot(WEIGHT ~ HEIGHT, data = data_class)

# Add a linear regression line
abline(lm(WEIGHT ~ HEIGHT, data = data_class)$coefficient)

# Add a LOWESS smooth line to show the general trend
lines(
  lowess(data_class$HEIGHT, data_class$WEIGHT),
  col = "blue"
)

# Calculate the correlation
cor(data_class$HEIGHT, data_class$WEIGHT)


# 20. DATA MANAGEMENT: CREATING A NEW VARIABLE
# ------------------------------------------------------------

# Attach the dataset so its columns can be accessed directly
attach(data_class)

# Calculate BMI using weight and height
BMI <- WEIGHT / (HEIGHT / 100)^2

# Round BMI values to two decimal places
BMI <- round(WEIGHT / (HEIGHT / 100)^2, digits = 2)

# Display the first five observations with BMI
head(cbind(data_class, BMI), n = 5)

# Add BMI as a new column to the dataset
new_data_class <- cbind(data_class, BMI)

# Display the last ten observations with BMI
tail(cbind(data_class, BMI), n = 10)

# Display summary statistics of BMI
summary(BMI)

# Display the distribution of BMI using a stem-and-leaf plot
stem(BMI, scale = 2)

# Detach the dataset after completing the operations
detach(data_class)


# 21. DATE OPERATIONS
# ------------------------------------------------------------

# Get the current system date
today <- Sys.Date()

# Display the date in month, day and year format
format(today, format = "%B %d %Y")

# Display the current day of the week
format(today, format = "%A")

# Define a date of birth
dob <- as.Date("1982-02-10")

# Calculate the difference between today and date of birth
difftime(today, dob, units = "days")

# Define a starting date
startdate <- as.Date("2004-02-13")

# Define an ending date
enddate <- as.Date("2011-01-22")

# Calculate the difference between the two dates
days <- enddate - startdate

# Display the number of days
days


# 22. CREATING A LEADERSHIP DATASET
# ------------------------------------------------------------

# Create manager identification numbers
manager <- c(1, 2, 3, 4, 5)

# Create country information
country <- c("US", "US", "UK", "UK", "UK")

# Create gender information
gender <- c("M", "F", "F", "M", "F")

# Create age information
age <- c(32, 45, 25, 39, 99)

# Create responses to five questionnaire questions
q1 <- c(5, 3, 3, 3, 2)
q2 <- c(4, 5, 5, 3, 2)
q3 <- c(5, 2, 5, 4, 1)
q4 <- c(5, 5, 5, NA, 2)
q5 <- c(5, 5, 2, NA, 1)

# Combine all variables into a data frame
leadership <- data.frame(
  manager, country, gender, age,
  q1, q2, q3, q4, q5
)

# Examine the structure of the dataset
str(leadership)

# Display the column names
names(leadership)


# 23. HANDLING MISSING VALUES IN THE LEADERSHIP DATASET
# ------------------------------------------------------------

# Replace age value 99 with NA
leadership$age[leadership$age == 99] <- NA

# Open the dataset to inspect changes
View(leadership)

# Create a new column called agecat
# Classify people older than 75 as Elder
leadership$agecat[leadership$age > 75] <- "Elder"

# Classify people between 35 and 75 as Middle Aged
leadership$agecat[
  leadership$age >= 35 & leadership$age <= 75
] <- "Middle Aged"

# Classify people younger than 35 as Young
leadership$agecat[leadership$age < 35] <- "Young"

# Identify missing values in questionnaire columns
is.na(leadership[, 5:9])

# Remove observations containing missing values
newdata <- na.omit(leadership)

# Display the cleaned dataset
newdata


# 24. SORTING DATA
# ------------------------------------------------------------

# Return the positions of ages in ascending order
order(leadership$age)

# Arrange the dataset according to age
newdata2 <- leadership[order(leadership$age), ]

# Display the sorted dataset
newdata2


# 25. SELECTING VARIABLES AND OBSERVATIONS (SUBSETTING)
# ------------------------------------------------------------

# Select columns 5 to 9
newdata3 <- leadership[, c(5:9)]

# Create a vector containing selected variable names
myvars <- c("q1", "q2", "q3", "q4", "q5")

# Select variables using their names
newdata3 <- leadership[myvars]

# Display the selected variables
newdata3

# Remove the first and second columns
newdata4 <- leadership[, c(-1, -2)]

# Remove columns 1 to 5
newdata4 <- leadership[, -(1:5)]

# Remove columns 1 and 7
newdata5 <- leadership[, c(-1, -7)]

# Select the fourth column using double brackets
leadership[[4]]

# Select the age column using the $ operator
leadership$age

# Select all rows except rows 1 and 3
newdata6 <- leadership[c(-1, -3), ]

# Select only rows 2, 4 and 5
newdata6 <- leadership[c(2, 4, 5), ]

# Select observations based on age conditions
# Keep selected questionnaire variables only
newdata7 <- subset(
  leadership,
  age >= 35 | age < 24,
  select = c(q1, q2, q3, q4, q5)
)

# Attach the leadership dataset
attach(leadership)

# Select male managers older than 30
newdata7 <- leadership[gender == "M" & age > 30, ]

# Detach the dataset
detach(leadership)


# 26. MERGING DATASETS
# ------------------------------------------------------------

# Merge two datasets horizontally using a common ID
# Example:
# merged_data <- merge(dataframeA, dataframeB, by = "ID")

# Merge datasets using two common variables
# Example:
# merged_data <- merge(
#   dataframeA,
#   dataframeB,
#   by = c("ID", "country")
# )

# Combine datasets vertically
# Both datasets must have the same columns
# Example:
# combined_data <- rbind(dataframeA, dataframeB)


# ============================================================
# END OF R PRACTICAL REVISION GUIDE
# ============================================================
