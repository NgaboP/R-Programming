# R Programming - My Practice Notes
# Class exercises and practice at home
#
# Topics I have been working on:
# Packages, basic R, ggplot2, apply functions and regression.
# I kept short notes beside the code so I can remember what I did.

# ==========================================================
# 1. PACKAGES
# ==========================================================

# First I check if the packages are installed.
# install.packages() is for installation; library() loads them.
packages <- c("ggplot2", "dplyr", "readr")
missing <- packages[!packages %in% rownames(installed.packages())]

if (length(missing) > 0) {
  install.packages(missing)
}

library(ggplot2)  # Graphs
library(dplyr)    # Data manipulation
library(readr)    # Reading data files


# ==========================================================
# 2. BASIC R PRACTICE
# ==========================================================

# 2.1 Variables and data types
# <- assigns a value to a variable.
# I used class() to check what type of data I stored.
student <- "Prince"
age <- 28
passed <- TRUE

print(student)
print(age)
print(passed)

class(student)  # character
class(age)      # numeric
class(passed)   # logical


# 2.2 Vectors
# c() combines values into a vector.
# Here I am finding basic statistics from five marks.
marks <- c(65, 70, 80, 90, 75)

print(marks)
length(marks)   # Number of values
sum(marks)      # Total
mean(marks)     # Average
median(marks)   # Middle value
max(marks)      # Highest
min(marks)      # Lowest


# 2.3 Sequences
# : gives consecutive whole numbers.
# seq() lets me choose the step; rep() repeats values.
numbers <- 1:10
print(numbers)

even_numbers <- seq(2, 20, by = 2)
print(even_numbers)

repeated_values <- rep(5, times = 4)
print(repeated_values)


# 2.4 Arithmetic operators
# I tried the common operators using two numbers.
a <- 20
b <- 5

a + b     # Addition
a - b     # Subtraction
a * b     # Multiplication
a / b     # Division
a %% b    # Remainder
a ^ 2     # Power


# 2.5 if / else
# The condition is checked first.
# If the score is at least 50, the student passes.
score <- 65

if (score >= 50) {
  print("Pass")
} else {
  print("Fail")
}


# 2.6 else if
# For more than two possible results, I can use else if.
score <- 78

if (score >= 80) {
  grade <- "A"
} else if (score >= 70) {
  grade <- "B"
} else if (score >= 60) {
  grade <- "C"
} else if (score >= 50) {
  grade <- "D"
} else {
  grade <- "F"
}

print(grade)  # B for this example


# 2.7 for loop
# This repeats the print statement for each number from 1 to 5.
for (i in 1:5) {
  print(i)
}


# 2.8 while loop
# This keeps running while counter <= 5.
# I must increase the counter so the loop can stop.
counter <- 1

while (counter <= 5) {
  print(counter)
  counter <- counter + 1
}


# 2.9 My own function
# I wrote a small function to calculate an average.
# x is the input and return() gives back the answer.
calculate_average <- function(x) {
  result <- mean(x)
  return(result)
}

calculate_average(c(10, 20, 30, 40))


# 2.10 Data frames
# A data frame has rows and columns, like a table.
students <- data.frame(
  Name = c("Aline", "Eric", "Jean", "Diane", "Peter"),
  Age = c(21, 22, 20, 23, 21),
  Marks = c(75, 60, 88, 45, 92)
)

print(students)
head(students)      # First rows
str(students)       # Column types
summary(students)   # Summary of the data


# ==========================================================
# 3. GGPLOT2 - DIFFERENT GEOMS
# ==========================================================

# General pattern I use:
# ggplot(data, aes(x = ..., y = ...)) + geom_...()
# aes() connects columns to the axes.
# Each geom makes a different kind of graph.

df <- data.frame(
  Student = c("Aline", "Eric", "Jean", "Diane", "Peter"),
  Gender = c("Female", "Male", "Male", "Female", "Male"),
  Marks = c(75, 60, 88, 45, 92),
  Study_Hours = c(4, 3, 6, 2, 7)
)


# 3.1 geom_bar()
# Counts the observations in each category.
# Here I am counting students by gender.
ggplot(df, aes(x = Gender)) +
  geom_bar(fill = "steelblue") +
  labs(
    title = "Students by Gender",
    x = "Gender",
    y = "Number of Students"
  )


# 3.2 geom_col()
# Unlike geom_bar(), this uses the y-values already in my data.
# Each bar shows a student's mark.
ggplot(df, aes(x = Student, y = Marks)) +
  geom_col(fill = "darkgreen") +
  labs(
    title = "Marks by Student",
    x = "Student",
    y = "Marks"
  )


# 3.3 geom_histogram()
# I use a histogram to see how numeric values are distributed.
# binwidth = 10 means each group covers 10 marks.
ggplot(df, aes(x = Marks)) +
  geom_histogram(
    binwidth = 10,
    fill = "orange",
    color = "black"
  ) +
  labs(
    title = "Distribution of Marks",
    x = "Marks",
    y = "Frequency"
  )


# 3.4 geom_boxplot()
# Shows the median, spread and possible outliers.
# I am comparing marks for the two gender groups.
ggplot(df, aes(x = Gender, y = Marks)) +
  geom_boxplot(fill = "lightblue") +
  labs(
    title = "Marks by Gender",
    x = "Gender",
    y = "Marks"
  )


# 3.5 geom_point()
# Scatter plot: useful for two numeric variables.
# I want to see the relationship between hours and marks.
ggplot(df, aes(x = Study_Hours, y = Marks)) +
  geom_point(size = 3, color = "red") +
  labs(
    title = "Study Hours and Marks",
    x = "Study Hours",
    y = "Marks"
  )


# 3.6 geom_line()
# A line graph is useful for showing changes over time.
monthly <- data.frame(
  Month = 1:6,
  Sales = c(120, 150, 135, 180, 200, 220)
)

ggplot(monthly, aes(x = Month, y = Sales)) +
  geom_line(linewidth = 1, color = "blue") +
  geom_point(size = 2) +
  labs(
    title = "Monthly Sales",
    x = "Month",
    y = "Sales"
  )


# 3.7 geom_smooth()
# method = "lm" adds a straight regression line.
# se = TRUE also shows the confidence band around the line.
ggplot(df, aes(x = Study_Hours, y = Marks)) +
  geom_point(size = 3) +
  geom_smooth(method = "lm", se = TRUE) +
  labs(
    title = "Study Hours and Marks - Trend",
    x = "Study Hours",
    y = "Marks"
  )

# What I need to remember:
# geom_bar() = counts, geom_col() = given values.
# histogram = distribution, boxplot = spread/outliers.
# point = relationship, line = trend, smooth = fitted trend.


# ==========================================================
# 4. APPLY FAMILY
# ==========================================================

# I practised these functions to avoid writing loops for
# common calculations.
#
# apply()  - rows or columns of a matrix
# lapply() - returns a list
# sapply() - tries to simplify the result
# vapply() - checks the expected output type
# tapply() - works with groups
# mapply() - works with multiple inputs

# A matrix of three students and three subjects.
scores <- matrix(
  c(
    70, 80, 90,
    60, 75, 85,
    88, 92, 95
  ),
  nrow = 3,
  byrow = TRUE
)

colnames(scores) <- c("Math", "English", "Science")
rownames(scores) <- c("Student1", "Student2", "Student3")
print(scores)


# 4.1 apply()
# MARGIN = 1 means rows; MARGIN = 2 means columns.
# First: average for each student.
row_averages <- apply(scores, MARGIN = 1, FUN = mean)
print(row_averages)

# Average for each subject.
column_averages <- apply(scores, MARGIN = 2, FUN = mean)
print(column_averages)

# I also tried totals instead of averages.
row_totals <- apply(scores, 1, sum)
column_totals <- apply(scores, 2, sum)
print(row_totals)
print(column_totals)


# 4.2 lapply()
# Applies mean() to each element of my list.
# The result stays a list.
my_list <- list(
  numbers = c(2, 4, 6),
  marks = c(60, 70, 80),
  ages = c(20, 21, 22)
)

list_means <- lapply(my_list, mean)
print(list_means)


# 4.3 sapply()
# Same calculation, but this result is a numeric vector.
simplified_means <- sapply(my_list, mean)
print(simplified_means)


# 4.4 vapply()
# numeric(1) says I expect one numeric answer per list item.
checked_means <- vapply(
  my_list,
  mean,
  FUN.VALUE = numeric(1)
)
print(checked_means)


# 4.5 tapply()
# I can calculate the average for each gender separately.
student_marks <- c(70, 80, 65, 90, 75, 85)
gender <- c("Female", "Male", "Female", "Male", "Female", "Male")

average_by_gender <- tapply(student_marks, gender, mean)
print(average_by_gender)


# 4.6 mapply()
# This applies sum() to corresponding pairs of list elements.
# First answer: sum(c(1, 2), c(10, 20)) = 33.
result_mapply <- mapply(
  FUN = sum,
  x = list(c(1, 2), c(3, 4), c(5, 6)),
  y = list(c(10, 20), c(30, 40), c(50, 60))
)

print(result_mapply)


# ==========================================================
# 5. LINEAR REGRESSION
# ==========================================================

# I used sample data to practise lm(), summary(), predict()
# and the diagnostic plots.
#
# Simple regression: one predictor.
# Multiple regression: two or more predictors.
#
# In this example:
# Y = Marks (what I want to predict)
# X = Study_Hours, or Study_Hours and Attendance

regression_data <- data.frame(
  Study_Hours = 1:10,
  Marks = c(42, 48, 51, 57, 61, 68, 72, 78, 84, 89),
  Attendance = c(60, 65, 70, 72, 75, 80, 82, 88, 90, 95)
)


# 5.1 Checking the data before modelling
head(regression_data)
summary(regression_data)
str(regression_data)


# 5.2 Simple linear regression
# Formula: Marks ~ Study_Hours
# lm() fits the model and summary() gives the results.
simple_model <- lm(
  Marks ~ Study_Hours,
  data = regression_data
)

summary(simple_model)

# Things I look for in summary():
# Coefficients - estimated intercept and slope.
# R-squared    - how much variation is explained by the model.
# p-value      - evidence about the relationship.
# Residuals    - differences between actual and fitted values.


# 5.3 Coefficients
# The slope estimates how Marks change for one extra hour.
# The intercept is the predicted Marks at zero study hours.
model_coefficients <- coef(simple_model)
print(model_coefficients)


# 5.4 Prediction
# I used predict() for students studying 5, 8 and 12 hours.
# 12 hours is outside the data range, so I should be careful
# when interpreting that prediction.
new_data <- data.frame(
  Study_Hours = c(5, 8, 12)
)

predicted_marks <- predict(
  simple_model,
  newdata = new_data
)

print(predicted_marks)


# 5.5 Plotting the regression line
# Points are the actual observations; the line is fitted.
ggplot(regression_data, aes(x = Study_Hours, y = Marks)) +
  geom_point(size = 3) +
  geom_smooth(method = "lm", se = TRUE) +
  labs(
    title = "Simple Linear Regression",
    x = "Study Hours",
    y = "Marks"
  )


# 5.6 Multiple linear regression
# Now I add Attendance as a second predictor.
# The + in the formula means I am including both variables.
multiple_model <- lm(
  Marks ~ Study_Hours + Attendance,
  data = regression_data
)

summary(multiple_model)

# I compare the coefficients and R-squared with the first
# model, but I also need to check assumptions and the data.


# 5.7 Prediction with two predictors
# The new data must include both Study_Hours and Attendance.
new_students <- data.frame(
  Study_Hours = c(5, 8),
  Attendance = c(75, 90)
)

multiple_predictions <- predict(
  multiple_model,
  newdata = new_students
)

print(multiple_predictions)


# 5.8 Regression diagnostic plots
# I used the standard four plots from plot(lm_model).
#
# Residuals vs Fitted: check linearity and equal spread.
# Normal Q-Q: check whether residuals are roughly normal.
# Scale-Location: another check of equal residual spread.
# Residuals vs Leverage: look for influential observations.
#
# These plots do not prove independence. For that, I also
# need to consider how the observations were collected.

par(mfrow = c(2, 2))
plot(simple_model)
par(mfrow = c(1, 1))



# ==========================================================
# 6. DEBUGGING IN R
# ==========================================================

# Debugging means finding and fixing errors in my code.
# I can use RStudio tools or R debugging functions.
#
# Common types of errors:
# - Syntax error: code is written incorrectly.
# - Runtime error: code starts but stops while running.
# - Logical error: code runs but gives the wrong answer.
#
# RSTUDIO DEBUGGING TOOLS
# - Breakpoint: click beside a line number to pause execution.
# - Step Into: move into a function to inspect its code.
# - Step Over: run the current line without entering a function.
# - Step Out: finish the current function and return to its caller.
# - Continue: resume running until the next breakpoint or end.
# - Environment: inspect the current values of variables.
# - Call Stack: see which functions called the current function.
#
# I can also use the following functions in R.


# 6.1 traceback()
# After an error occurs, traceback() shows the sequence of
# function calls that led to the error.
# Run traceback() immediately after an error in the Console.
#
# Example of an error (kept as a comment so the whole script
# does not stop when it is run):
# mean("hello")
# traceback()


# 6.2 browser()
# browser() pauses a function at a chosen line.
# While paused, I can inspect variables and run expressions.
# Type "c" in the Console to continue.
#
# This function contains browser(), so running it will pause
# the script. Uncomment the call only when I want to practise.
debug_example <- function(x) {
  total <- sum(x)
  browser()  # Pause here and inspect x and total
  average <- total / length(x)
  return(average)
}

# Uncomment to test the browser:
# debug_example(c(10, 20, 30))


# 6.3 debug() and undebug()
# debug() makes R enter a function step by step when it is called.
# undebug() turns this behaviour off again.
#
# Uncomment these lines to practise:
# debug(calculate_average)
# calculate_average(c(10, 20, 30))
# undebug(calculate_average)


# 6.4 debugonce()
# debugonce() is like debug(), but it debugs the function
# only the next time it is called.
#
# Uncomment to practise:
# debugonce(calculate_average)
# calculate_average(c(10, 20, 30))


# 6.5 recover()
# recover() allows me to choose a function environment to inspect
# after an error. This is useful when a function calls another
# function and I need to find where the problem started.
#
# I can enable it for an interactive debugging session with:
# options(error = recover)
#
# To return to the normal error behaviour afterwards:
# options(error = NULL)


# 6.6 try() and tryCatch()
# try() lets the script continue after an expression produces
# an error. The error is reported, but later code can run.
try(log("not a number"))

# tryCatch() lets me decide what to do when an error happens.
# Here I display a simple message instead of stopping the script.
result <- tryCatch(
  {
    log("not a number")
  },
  error = function(e) {
    message("I found an error: ", e$message)
    NA
  }
)

print(result)


# 6.7 stopifnot()
# stopifnot() checks conditions that should be TRUE.
# If a condition is FALSE, R stops and reports an error.
# I can use it to check assumptions in my code.

test_values <- c(10, 20, 30)
stopifnot(is.numeric(test_values))
stopifnot(length(test_values) == 3)


# What I need to remember:
# traceback() = inspect the calls that led to an error.
# browser() = pause inside a function and inspect values.
# debug() = step through a function each time it is called.
# debugonce() = debug it for the next call only.
# undebug() = stop debugging a function.
# recover() = choose a function environment after an error.
# try() / tryCatch() = handle errors so code can continue.
# stopifnot() = check that required conditions are TRUE.


# ==========================================================
# 7. THINGS TO PRACTISE AGAIN
# ==========================================================

# [ ] Create a vector and calculate mean, median, max and min.
# [ ] Write if/else for positive and negative numbers.
# [ ] Print 1 to 10 using a for loop.
# [ ] Make a bar chart and a histogram.
# [ ] Find row and column totals using apply().
# [ ] Compare the output of lapply() and sapply().
# [ ] Fit a simple regression model using lm().
# [ ] Fit a multiple regression model.
# [ ] Predict Marks for 6 study hours.
# [ ] Explain the four diagnostic plots in my own words.

# End of my R practice notes.
